"""Testes SQLite em memória; não criam base operacional nem serviços."""
from pathlib import Path
import sqlite3
import re

ROOT = Path(__file__).resolve().parents[1]

def statements(name):
    return [s.strip() for s in (ROOT/'sql'/name).read_text().split(';') if s.strip()]

def run(db, name, index=0, **params):
    return db.execute(statements(name)[index], params)

def main():
    db = sqlite3.connect(':memory:')
    db.executescript((ROOT/'sql/00_schema.sql').read_text())
    db.executescript((ROOT/'sql/00_schema.sql').read_text())
    # Compilar todas as consultas, incluindo parâmetros, sem mutar dados.
    for path in (ROOT/'sql').glob('*.sql'):
        if path.name == '00_schema.sql':
            continue
        for stmt in statements(path.name):
            params = dict.fromkeys(re.findall(r':([a-z_]+)', stmt), None)
            db.execute('EXPLAIN ' + stmt, params)
    run(db,'90_setup_e_estado.sql', projeto_id='tatu', nome='Tatu Achou')
    assert db.execute('SELECT estado, midia_autorizada, video_disponivel, voz_disponivel FROM tatu_projetos').fetchone() == ('setup',0,0,0)
    run(db,'90_setup_e_estado.sql',1,projeto_id='tatu',evidencia='estudio/02-gestao/decisoes/teste.md')
    run(db,'10_gestao.sql',1,projeto_id='tatu',tarefa_id='copy',pedido='Legenda',objetivo='Identificação',agente='07',pasta='estudio/07-copywriting',criterio='Texto claro')
    run(db,'10_gestao.sql',1,projeto_id='tatu',tarefa_id='copy',pedido='Duplicado',objetivo='X',agente='07',pasta='estudio/07-copywriting',criterio='X')
    assert db.execute('SELECT count(*) FROM tatu_tarefas').fetchone()[0] == 1
    run(db,'35_copywriting.sql',1,projeto_id='tatu',tarefa_id='copy',versao=1,arquivo='estudio/07-copywriting/copy.md',resumo='Legenda textual')
    run(db,'40_revisao.sql',1,projeto_id='tatu',tarefa_id='copy',versao=1,veredito='aprovado',parecer='estudio/08-revisao/copy.md')
    assert db.execute('SELECT estado FROM tatu_tarefas').fetchone()[0] == 'revisado'
    # Aprovação editorial sozinha não libera publicação.
    assert run(db,'60_publicacao.sql',projeto_id='tatu').fetchall() == []
    run(db,'60_publicacao.sql',1,projeto_id='tatu',tarefa_id='copy',versao=1,conta='conta-teste',autorizacao_ref='estudio/02-gestao/aprovacoes/copy.md')
    assert len(run(db,'60_publicacao.sql',projeto_id='tatu').fetchall()) == 1
    run(db,'10_gestao.sql',2,projeto_id='tatu',tarefa_id='copy',versao=1,motivo='Nova redação')
    assert run(db,'60_publicacao.sql',projeto_id='tatu').fetchall() == [], 'Aprovação antiga não vale para nova versão'
    # Bloqueio impede entrega. Retomada exige resolução e volta ao autor.
    run(db,'70_bloqueios.sql',projeto_id='tatu',tarefa_id='copy',versao=2,motivo='Referência ausente',acao='Pedir ao Gestor')
    run(db,'35_copywriting.sql',1,projeto_id='tatu',tarefa_id='copy',versao=2,arquivo='estudio/07-copywriting/copy.md',resumo='Sem acesso')
    assert db.execute('SELECT estado FROM tatu_tarefas').fetchone()[0] == 'bloqueado'
    run(db,'70_bloqueios.sql',1,projeto_id='tatu',tarefa_id='copy',versao=2,resolucao='Referência recebida')
    assert db.execute('SELECT estado FROM tatu_tarefas').fetchone()[0] == 'em_execucao'
    run(db,'50_custos.sql',projeto_id='tatu',tarefa_id='copy',chave='op-1',agente='07',servico='teste',valor=None,medido=0,autorizacao_ref=None)
    assert run(db,'50_custos.sql',2,projeto_id='tatu').fetchone() == (None,1)
    assert db.execute('SELECT versao FROM tatu_tarefas').fetchone()[0] == 3
    # Isolamento entre projetos e proteção contra caminhos fora de estudio/.
    assert run(db,'60_publicacao.sql',projeto_id='outro').fetchall() == []
    try:
        run(db,'10_gestao.sql',1,projeto_id='tatu',tarefa_id='fora',pedido='X',objetivo='X',agente='07',pasta='estudio/../privado',criterio='X')
    except sqlite3.IntegrityError:
        pass
    else:
        raise AssertionError('Caminho externo aceito')
    for column in ['midia_autorizada','video_disponivel','voz_disponivel']:
        try:
            db.execute(f'UPDATE tatu_projetos SET {column}=1')
        except sqlite3.IntegrityError:
            pass
        else:
            raise AssertionError('Mídia foi habilitada')
    assert db.execute('PRAGMA foreign_key_check').fetchall() == []
    print('PASS: 13 arquivos SQL, schema idempotente, consultas compiladas, fluxo textual, revisão por versão, publicação, bloqueios e custos desconhecidos.')

if __name__ == '__main__':
    main()

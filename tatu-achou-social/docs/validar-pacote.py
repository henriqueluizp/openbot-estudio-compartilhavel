"""Valida o pacote descritivo; não acessa OpenBot nem instala serviços."""
from pathlib import Path
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
BUNDLE = ROOT / 'PROMPT_UNICO_OPENBOT.txt'


def bundle_text():
    parts = ['TATU ACHOU SOCIAL — PACOTE TEXTUAL PARA CONFIGURAÇÃO MANUAL\n'
             'Leia primeiro PROMPT_INSTALACAO.md. Cada seção é um arquivo independente; '
             'cole somente o prompt do agente correspondente em suas instruções. '
             'Não simule agentes criados, mensagens ou ferramentas. Não gerar mídia.\n']
    manifest = json.loads((ROOT / 'manifesto.json').read_text())
    parts.append('DIRETÓRIOS RELATIVOS À RAIZ tatu-achou-social/:\n' + '\n'.join(manifest['pastas']) + '\n')
    files = sorted(p for p in ROOT.rglob('*') if p.suffix in {'.md', '.json'})
    installer = ROOT / 'PROMPT_INSTALACAO.md'
    files.remove(installer)
    for path in [installer] + files:
        rel = path.relative_to(ROOT).as_posix()
        parts.append(f'\n===== INÍCIO {rel} =====\n{path.read_text().rstrip()}\n===== FIM {rel} =====\n')
    return '\n'.join(parts)


def main():
    if '--gerar' in sys.argv:
        BUNDLE.write_text(bundle_text())
    m = json.loads((ROOT / 'manifesto.json').read_text())
    for p in ROOT.rglob('*.json'):
        json.loads(p.read_text())
    assert len(m['agentes']) == 8
    assert len({a['nome'] for a in m['agentes']}) == 8
    assert {a['id'] for a in m['agentes']} == {f'{n:02d}' for n in range(1, 9)}
    assert [a['id'] for a in m['agentes'] if a['contato_usuario']] == ['01']
    assert {a['prompt'] for a in m['agentes']} == {p.relative_to(ROOT).as_posix() for p in (ROOT/'agentes').glob('*.md')}
    for a in m['agentes']:
        s = (ROOT / a['prompt']).read_text()
        assert a['nome'] in s
        for term in ['Colaboração autossuficiente', 'Entrada:', 'Entrega:', 'Não gere mídia', 'não simule respostas', 'Gestor']:
            assert term in s, (a['id'], term)
        assert a['responde_a'] == (None if a['id'] == '01' else '01')
    for path in [m['hierarquia'], m['briefing'], *m['documentos'].values()]:
        assert (ROOT / path).is_file(), path
    for path in m['pastas']:
        assert (ROOT / path).is_dir(), path
    assert len(list((ROOT/'estudio').glob('[0-9][0-9]-*'))) == 10
    assert not list(ROOT.glob('[0-9][0-9]-*'))
    assert m['estado']['producao_de_midia_autorizada'] is False
    assert m['estado']['publicacao_autorizada'] is False
    assert m['estado']['agentes_instalados'] is False
    assert BUNDLE.read_text() == bundle_text(), 'Texto único desatualizado: execute --gerar'
    secret = re.compile(r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----|\bgh[pousr]_[A-Za-z0-9]{30,}|\bsk-[A-Za-z0-9_-]{24,}|\bAKIA[A-Z0-9]{16}\b')
    for p in ROOT.rglob('*'):
        if p.is_file() and p.suffix in {'.md', '.json', '.txt'}:
            s = p.read_text()
            assert not secret.search(s), f'Possível segredo: {p.relative_to(ROOT)}'
            assert '/Users/' not in s, f'Caminho pessoal: {p.relative_to(ROOT)}'
            assert 'tatu-achou-social/02-gestao/' not in s, 'Referência anterior à migração'
    print('PASS: 8 agentes, JSONs, caminhos, 10 pastas de trabalho, regras, texto único e varredura de credenciais.')


if __name__ == '__main__':
    main()

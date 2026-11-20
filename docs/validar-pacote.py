"""Valida o pacote descritivo; não acessa OpenBot nem instala serviços."""
from pathlib import Path
import json
import re
import sys
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUNDLE = ROOT / 'PROMPT_UNICO_OPENBOT.txt'


def package_files():
    # Inventário explícito impede embutir legado, .git ou arquivos locais privados.
    manifest = json.loads((ROOT / 'manifesto.json').read_text())
    files = {ROOT / name for name in [
        'README.md', 'manifesto.json', manifest['hierarquia'], *manifest['documentos'].values()
    ]}
    for folder in {path.split('/')[0] for path in manifest['pastas']}:
        files.update(p for p in (ROOT / folder).rglob('*')
                     if p.is_file() and p.suffix in {'.md', '.json', '.sql'})
    files.discard(BUNDLE)
    return sorted(files)


def bundle_text():
    parts = ['TATU ACHOU SOCIAL — PACOTE TEXTUAL PARA CONFIGURAÇÃO MANUAL\n'
             'Leia primeiro PROMPT_INSTALACAO.md. Cada seção é um arquivo independente; '
             'cole somente o prompt do agente correspondente em suas instruções. '
             'Não simule agentes criados, mensagens ou ferramentas. Não gerar mídia.\n']
    manifest = json.loads((ROOT / 'manifesto.json').read_text())
    parts.append('DIRETÓRIOS RELATIVOS À RAIZ DO REPOSITÓRIO:\n' + '\n'.join(manifest['pastas']) + '\n')
    files = package_files()
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
    for p in package_files():
        if p.suffix == '.json':
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
        assert (ROOT / a['sql']).is_file()
        assert a['sql'] in s
    for path in [m['hierarquia'], m['briefing'], *m['documentos'].values()]:
        assert (ROOT / path).is_file(), path
    for path in m['pastas']:
        assert (ROOT / path).is_dir(), path
    assert len(list((ROOT/'estudio').glob('[0-9][0-9]-*'))) == 10
    assert not list(ROOT.glob('[0-9][0-9]-*'))
    assert m['estado']['producao_de_midia_autorizada'] is False
    assert m['estado']['publicacao_autorizada'] is False
    assert m['estado']['agentes_instalados'] is False
    assert len({a['sql'] for a in m['agentes']}) == 8
    assert set(m['sql']['arquivos']) == {p.relative_to(ROOT).as_posix() for p in (ROOT/'sql').glob('*.sql')}
    assert len(m['sql']['arquivos']) == 13
    assert m['sql']['integracao_testada'] is False
    assert not (ROOT / 'tatu-achou-social').exists()
    assert BUNDLE.read_text() == bundle_text(), 'Texto único desatualizado: execute --gerar'
    assert '===== INÍCIO legado/' not in BUNDLE.read_text()
    secret = re.compile(r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----|\bgh[pousr]_[A-Za-z0-9]{30,}|\bsk-[A-Za-z0-9_-]{24,}|\bAKIA[A-Z0-9]{16}\b')
    for p in [*package_files(), BUNDLE]:
        if p.is_file():
            s = p.read_text()
            assert not secret.search(s), f'Possível segredo: {p.relative_to(ROOT)}'
            assert '/Users/' not in s, f'Caminho pessoal: {p.relative_to(ROOT)}'
            assert 'tatu-achou-social/' not in s, 'Referência anterior à migração'
    subprocess.run([sys.executable, str(ROOT/'docs/testar-sql.py')], check=True)
    print('PASS: 8 agentes, 13 SQLs, JSONs, caminhos na raiz, 10 pastas de trabalho, regras, texto único e varredura de credenciais.')


if __name__ == '__main__':
    main()

# Compartilhar e reinstalar a estrutura

## Compartilhamento

Envie a pasta (ou o ZIP) completa, ou apenas `PROMPT_UNICO_OPENBOT.txt`. A pasta mantém os arquivos editáveis e as consultas separadas; o prompt único incorpora todo o conteúdo necessário para reconstruí-los no destino.

Quem recebe abre o instalador no próprio OpenBot, responde às perguntas sobre negócio, fontes e ferramentas e recebe os quatro agentes com IDs próprios. O manifesto descreve a operação; não substitui as ferramentas nativas de criação de agentes.

## Reexportar uma adaptação

Depois de configurar um projeto, sua versão compartilhável pode conter:

- os prompts dos quatro papéis e o manifesto, sem IDs de contas ou agentes existentes;
- uma configuração de exemplo, com dados particulares substituídos por campos a preencher;
- bíblia, fluxo, modelos e consultas do banco vazio;
- o contrato técnico e o código do motor que você tenha direito de distribuir;
- assets próprios ou licenciados para esse compartilhamento, com os respectivos créditos.

Gere o ZIP a partir de uma lista explícita de arquivos. Exclua segredos, configuração do cofre, sessões, bancos com dados reais, histórico de conversa, episódios, custos realizados, caches, dependências instaladas e renders. Credenciais são recriadas por quem recebe.

Se incluir um motor próprio, elimine caminhos absolutos e dependências de outro projeto, documente as dependências e valide um teste em uma raiz diferente. Um ZIP só de instruções continua útil sem o motor, desde que a pendência audiovisual esteja explícita.

## Regenerar o prompt único

`PROMPT_UNICO_OPENBOT.txt` é composto de um cabeçalho, o conteúdo de `PROMPT_INSTALACAO.md` e um apêndice com cada arquivo do pacote entre os marcadores `<<< ARQUIVO caminho >>>` e `<<< FIM DO ARQUIVO caminho >>>`. Ao alterar qualquer arquivo, regenere o prompt único para manter as duas formas de instalação iguais.

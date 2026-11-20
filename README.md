# Tatu Achou Social — equipe para OpenBot

Pacote de configuração manual de oito especialistas para o Instagram do Tatu Achou, com o **Gestor do Projeto como único contato do proprietário**. Contém prompts de sistema, hierarquia, manifesto, pastas compartilhadas e briefing da operação “Faça o público conhecer o Tatu”.

## Configuração manual

1. Disponibilize `tatu-achou-social/` ao OpenBot e confirme que ele consegue ler e gravar a pasta adequada.
2. Crie no app os oito agentes e cole em cada campo de instruções de sistema o arquivo correspondente em [`tatu-achou-social/agentes/`](tatu-achou-social/agentes/).
3. Consulte o [manifesto](tatu-achou-social/MANIFESTO.md) e a [hierarquia](tatu-achou-social/HIERARQUIA.md). Teste a comunicação e o compartilhamento reais antes de confiar em delegações. O [manifesto JSON](tatu-achou-social/manifesto.json) é descritivo, não um formato de importação nativo.
4. Envie ao Gestor o [briefing da primeira operação](tatu-achou-social/estudio/02-gestao/briefings/operacao-conhecer-tatu.md). Ele consolida entregas e dúvidas; o proprietário aprova antes de publicar.

Os agentes ainda não foram criados nem testados. A existência dos arquivos não comprova colaboração ou acesso no OpenBot. Vídeo e voz estão indisponíveis nesta squad; nesta operação não se gera mídia. Um roteiro ou prompt não é vídeo ou arte final. A primeira missão continua pendente até a configuração e a realização efetivas.

O repositório é público: não armazene credenciais ou informações confidenciais. O conteúdo anterior do estúdio de animação de quatro agentes foi preservado em [`legado/`](legado/LEIA-ME.md); suas instruções e manifesto são independentes deste time.

## Formato do pacote

O Tatu segue a organização de pacote do legado: `agentes/`, `config/`, `consultas/`, `docs/`, `estudio/`, `modelos/` e `rotinas/`, com controle por arquivos, sem dependência SQL. As pastas de trabalho `01-marca` a `10-relatorios` agora ficam em `tatu-achou-social/estudio/`.

Use o [LEIA-ME](tatu-achou-social/LEIA-ME.md), o [prompt de instalação](tatu-achou-social/PROMPT_INSTALACAO.md) ou o [pacote em texto único](tatu-achou-social/PROMPT_UNICO_OPENBOT.txt). Consulte o [mapeamento com o legado](tatu-achou-social/docs/mapeamento.md) e a [validação por agente](tatu-achou-social/docs/validacao.md). A reorganização não instala agentes no OpenBot nem executa a campanha.

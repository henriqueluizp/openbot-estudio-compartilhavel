# Compartilhar e reinstalar

Distribua apenas prompts, configuração de exemplo, modelos e documentação públicos. Faça cópia privada para execução. Não inclua credenciais, IDs internos de contas, dados de clientes ou relatórios confidenciais.

No destino, siga `../PROMPT_INSTALACAO.md`; crie os oito agentes manualmente e teste comunicação e arquivos. Nunca transporte alegações de “instalado” ou “testado” de outro ambiente. O manifesto é descritivo, não um importador.

As pastas numeradas antes na raiz agora estão em `estudio/`, incluindo o briefing. Atualize caminhos de instalações antigas, sem apagar seus dados. Não altere `legado/`, que é um pacote independente.

Ao mudar prompts ou arquivos textuais, regenere `PROMPT_UNICO_OPENBOT.txt` com `python3 docs/validar-pacote.py --gerar` a partir da raiz do repositório e depois valide sem a opção. O arquivo único contém os documentos Markdown/JSON e SQL do Tatu, exceto ele próprio, scripts de validação, legado e arquivos locais; `.gitkeep` é representado pela lista de diretórios.

O conteúdo do pacote Tatu está diretamente na raiz do repositório. Bancos `.db`, recibos privados e credenciais não devem ser publicados.

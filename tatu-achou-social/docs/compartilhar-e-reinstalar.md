# Compartilhar e reinstalar

Distribua apenas prompts, configuração de exemplo, modelos e documentação públicos. Faça cópia privada para execução. Não inclua credenciais, IDs internos de contas, dados de clientes ou relatórios confidenciais.

No destino, siga `../PROMPT_INSTALACAO.md`; crie os oito agentes manualmente e teste comunicação e arquivos. Nunca transporte alegações de “instalado” ou “testado” de outro ambiente. O manifesto é descritivo, não um importador.

As pastas numeradas antes na raiz agora estão em `estudio/`, incluindo o briefing. Atualize caminhos de instalações antigas, sem apagar seus dados. Não altere `legado/`, que é um pacote independente.

Ao mudar prompts ou arquivos textuais, regenere `PROMPT_UNICO_OPENBOT.txt` com `python3 tatu-achou-social/docs/validar-pacote.py --gerar` a partir da raiz do repositório e depois valide sem a opção. O arquivo único contém todos os documentos textuais, exceto ele próprio e o script de validação; `.gitkeep` é representado pela lista de diretórios.

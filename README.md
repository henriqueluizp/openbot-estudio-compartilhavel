# Tatu Achou Social — equipe para OpenBot

Pacote de oito especialistas para o Instagram do Tatu Achou, com o **Gestor do Projeto como único contato do proprietário**. O pacote está diretamente na raiz deste repositório.

Para instalar, copie o [prompt de instalação](PROMPT_INSTALACAO.md) e envie ao agente local ou ao OpenBot. Ele orienta a preparação do computador e a configuração dos oito agentes. O [LEIA-ME](LEIA-ME.md) explica o pacote; o [texto único](PROMPT_UNICO_OPENBOT.txt) reúne seus documentos e SQL para transferência textual.

- [agentes/](agentes/): oito prompts de sistema independentes.
- [manifesto.json](manifesto.json): inventário descritivo, não importador nativo.
- [config/](config/), [consultas/](consultas/), [modelos/](modelos/) e [rotinas/](rotinas/): referências de configuração e operação.
- [estudio/](estudio/): pastas compartilhadas de `01-marca` a `10-relatorios` e briefing da primeira missão.
- [sql/](sql/): schema SQLite, oito papéis, custos, publicação, bloqueios e setup. Veja [como usar](docs/sql.md) em uma base privada dedicada.
- [docs/](docs/): configuração detalhada, mapeamento e validação.
- [legado/](legado/LEIA-ME.md): pacote anterior preservado, independente do Tatu.

Os agentes ainda precisam ser criados e testados no OpenBot. Não gerar mídia nesta operação: vídeo e voz estão indisponíveis. Roteiros e especificações não são arquivos finais. Publicação, agendamento e gastos exigem autorização do proprietário.

Valide na raiz com `python3 docs/validar-pacote.py`. Depois de editar documentos, regenere o texto único com `python3 docs/validar-pacote.py --gerar`. Os testes SQL usam somente uma base em memória. O repositório é público: mantenha credenciais e dados operacionais em uma cópia privada.

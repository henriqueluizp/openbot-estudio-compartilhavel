# Tatu Achou Social — pacote para OpenBot

Oito especialistas para construir a marca Tatu Achou no Instagram. O Gestor do Projeto é o único contato do proprietário. Este pacote contém instruções para configuração manual, não agentes instalados nem integração nativa.

## Configuração

1. Disponibilize uma cópia da pasta ao OpenBot e confirme leitura e escrita em um workspace privado.
2. Siga `PROMPT_INSTALACAO.md` e cole integralmente cada arquivo de `agentes/` no agente correspondente. Os oito prompts funcionam isoladamente e repetem contexto, equipe, limites e protocolo de entrega.
3. Alternativamente, cole `PROMPT_UNICO_OPENBOT.txt`: contém instruções de instalação e todo o conteúdo textual do pacote, com separadores de arquivo. Isso não comprova criação automática de agentes.
4. Execute a validação de comunicação em `docs/validacao.md`. Registre ferramentas e pendências sem credenciais.
5. Envie ao Gestor `estudio/02-gestao/briefings/operacao-conhecer-tatu.md`. O piloto segue pendente: esta reorganização não executa a campanha.

## Mapa

| Caminho | Responsabilidade |
| --- | --- |
| `agentes/` | Oito prompts de sistema independentes |
| `config/` | Configuração descritiva e estado inicial das ferramentas |
| `consultas/` | Pedidos ao Gestor e protocolo de pesquisa |
| `docs/` | Validação, portabilidade e mapeamento do pacote |
| `estudio/` | Área compartilhada de trabalho, pastas 01 a 10 e briefing |
| `modelos/` | Fichas reutilizáveis de tarefas, pesquisa, calendário, roteiro, carrossel, revisão e relatórios |
| `rotinas/` | Frequência editorial proposta, sem automação ativada |
| `manifesto.json` | Inventário, agentes, caminhos, hierarquia e estados |
| `MANIFESTO.md` / `HIERARQUIA.md` | Regras editoriais, autoridade e fluxo |

`sql/` contém schema e consultas SQLite para os oito papéis, custos, publicação, bloqueios e setup. O uso é opcional, em base privada dedicada: leia `docs/sql.md`. Não existe integração de banco confirmada no OpenBot.

## Limites atuais

Não gerar mídia nesta operação. Vídeo e voz indisponíveis por falta de chave; não solicitar chaves no chat. Reel é roteiro/storyboard textual; carrossel é especificação por página, sem arte final. Não declarar a campanha completa enquanto seus materiais obrigatórios estiverem ausentes. Não publicar, agendar, gastar, instalar ferramentas ou conectar serviços sem a autorização correspondente. A revisão técnica de mídia permanece bloqueada.

O repositório é público. Mantenha credenciais no mecanismo seguro do ambiente e dados operacionais privados fora do Git público. Versão do pacote: 1.2.0.

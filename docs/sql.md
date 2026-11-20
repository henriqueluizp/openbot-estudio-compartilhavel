# Controle SQLite do Tatu

O SQL é opcional e específico dos oito papéis do Tatu. Não contém o motor de animação do legado. Os arquivos Markdown/JSON continuam guardando briefing, dependências, prazo, fontes, aprovações e critérios de aceite. O banco indexa tarefas, versões, entregas, pareceres, custos e publicação. Não é integração nativa do OpenBot nem mecanismo de autenticação.

## Preparação e uso

1. Obtenha confirmação antes de instalar programas ou conectar serviços. Use uma base SQLite dedicada em workspace privado, fora do Git público; nunca abra o banco interno do OpenBot.
2. Aplique `sql/00_schema.sql`. Ative `PRAGMA foreign_keys = ON` em cada conexão. O schema pode ser reaplicado sem apagar dados. Não execute todos os arquivos SQL em lote: os outros arquivos são catálogos de operações independentes.
3. Vincule parâmetros nomeados `:projeto_id`, `:tarefa_id`, `:versao` etc. pelo executor SQLite. Não substitua strings por concatenação. Cada instrução deve ser executada separadamente; zero linhas alteradas significa pré-condição não atendida ou operação já registrada, nunca sucesso presumido.
4. Em `90_setup_e_estado.sql`, crie o projeto no estado `setup`. Só registre `textual` após comprovar comunicação e acesso aos arquivos. Mídia, vídeo e voz ficam desativados por restrição do schema deste pacote.
5. O Gestor cria tarefas em `10_gestao.sql`. O autor grava o arquivo de verdade antes de registrar a entrega. O Revisor lê a versão e salva seu parecer. Ajustes exigem nova versão pelo Gestor; versões antigas permanecem no histórico e não liberam publicação da nova versão.
6. Bloqueios preservam o motivo; a retomada pelo Gestor cria nova versão. Não contorne falta de ferramentas alterando o banco. Nenhuma consulta comprova que o arquivo existe: o agente precisa verificar isso no armazenamento real.

| Arquivo | Responsabilidade e arquivos de trabalho |
| --- | --- |
| `00_schema.sql` | Schema, oito papéis, tarefas, entregas, revisões, custos, publicação e fila |
| `05_pesquisa.sql` | Pesquisa com fontes/data, hipóteses separadas; `estudio/03-pesquisas/` |
| `10_gestao.sql` | Tarefas, versões e consolidação; `estudio/02-gestao/`, relatórios em `estudio/10-relatorios/` |
| `15_coordenacao_criativa.sql` | Conceitos e direção; `estudio/04-estrategia/campanhas/` |
| `18_estrategia.sql` | Calendário e objetivos; `estudio/04-estrategia/calendario-editorial/` |
| `20_design.sql` | Especificações textuais; `estudio/05-design/` |
| `30_reels.sql` | Roteiros e storyboards; `estudio/06-reels/`, sem render nem voz |
| `35_copywriting.sql` | Textos, legendas e CTAs; `estudio/07-copywriting/` |
| `40_revisao.sql` | Parecer independente por versão; `estudio/08-revisao/` |
| `50_custos.sql` | Custos em BRL, estimados ou medidos; desconhecido é NULL |
| `60_publicacao.sql` | Autorização específica por versão/conta e recibo externo, nunca envio |
| `70_bloqueios.sql` | Motivo, ação necessária e resolução comprovada |
| `90_setup_e_estado.sql` | Setup, teste textual, pausa e retomada |

## Limites de autoridade

O banco não controla permissões de agentes. Restrinja o executor conforme o papel: só o Gestor registra autorização já recebida, custos exigem decisão prévia de gasto, e o Revisor não aprova a própria correção. Não use SQL para inventar autorização. O documento em `estudio/02-gestao/aprovacoes/` deve identificar versão, conta, ação e escopo; antes de ação externa confira se continua válido. A fila SQL não é uma ordem de publicar. Recibos vêm do serviço real. Neste pacote não há conector de publicação.

Uma tarefa textual revisada não representa um Reel ou carrossel final. `estudio/09-aprovados/` só recebe cópias de arquivos existentes aprovados, por operação explícita do Gestor. A revisão técnica de mídia permanece bloqueada. Os registros privados não acompanham a distribuição pública.

## Verificação

Execute `python3 docs/testar-sql.py`. Os testes usam SQLite em memória e não instalam nem conectam serviços. O validador principal também executa esse teste.

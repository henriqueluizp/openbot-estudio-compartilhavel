# Estúdio de conteúdo animado para OpenBot

Pacote para montar, no OpenBot, uma operação de vídeos curtos animados com IA, produzidos em escala por quatro agentes: coordenação e roteiro, arte, produção audiovisual e revisão independente. A estrutura, os formatos e o fluxo vêm prontos; marca, assunto, fontes, elenco, ferramentas, custos e publicação são definidos por você no setup.

O pacote é uma especificação portátil, composta de prompts, modelos e SQL. Ele não traz motor de render, personagens, vozes, vídeos, credenciais nem dados de outra operação.

## Como instalar

1. No OpenBot de destino, anexe a pasta (ou o ZIP) e envie o texto de `PROMPT_INSTALACAO.md`. Se preferir colar um único texto, use todo o conteúdo de `PROMPT_UNICO_OPENBOT.txt`.
2. Responda às perguntas do instalador. Ele aproveita o que você já informou e pergunta apenas o que falta, em blocos de até três perguntas.
3. Confira, no `RELATORIO-INSTALACAO.md` gerado, os quatro agentes criados, as fontes testadas e as pendências.
4. Peça um piloto à Coordenação (veja `consultas/pedidos-por-agente.md`).
5. Depois de aprovar o piloto, ative a rotina e, se quiser, a publicação. Cada uma é uma autorização separada.

`manifesto.json` descreve o que deve ser criado; ele não é um formato nativo de importação do OpenBot. O instalador usa as ferramentas disponíveis na instalação de destino ou entrega as instruções manuais equivalentes.

## Os quatro agentes

| Papel (chave) | Responsabilidade | Entrega principal |
| --- | --- | --- |
| Coordenação (`coordenacao`) | Pauta, pesquisa, roteiro, coordenação, custos e entrega | Roteiro com fontes e fila atualizada |
| Arte (`arte`) | Identidade visual, personagens, objetos e storyboard | Plano de cenas e assets consistentes |
| Produção (`producao`) | Vozes, animação, legenda, som, render e master | Vídeo, quadros de conferência e relatório técnico |
| Revisão (`revisao`) | Revisão independente do roteiro e do vídeo | Parecer com evidência e correção pedida |

O nome de exibição de cada agente é escolhido no setup e registrado em `AGENTES.json`; a chave do papel não muda. Publicação é uma integração opcional, fora desses quatro papéis.

## Mapa do pacote

| Caminho | Conteúdo |
| --- | --- |
| `PROMPT_INSTALACAO.md` | Prompt do instalador, para usar com o pacote anexado |
| `PROMPT_UNICO_OPENBOT.txt` | Instalador com todos os arquivos incorporados, para colar como texto |
| `manifesto.json` | Agentes, etapas, pastas e localização dos arquivos |
| `agentes/` | Prompt de sistema de cada agente |
| `config/projeto.exemplo.json` | Configuração completa a preencher no setup |
| `config/perfil-nicho.exemplo.json` | Exemplo de como adaptar o estúdio a um nicho |
| `modelos/` | Bíblia, fluxo, formatos, roteiro, ficha de fonte, storyboard, parecer, produção, publicação e relatórios |
| `estudio/REQUISITOS.md` | Contrato técnico do motor audiovisual e perfil de referência |
| `sql/` | Esquema SQLite e consultas de cada papel |
| `consultas/` | Pedidos prontos para os agentes e modelos de busca de fontes |
| `rotinas/fabrica.md` | Prompt da rotina recorrente, criada desativada |
| `docs/validacao.md` | Como validar a instalação no destino |
| `docs/compartilhar-e-reinstalar.md` | Como reexportar uma adaptação sem levar dados privados |

## Estrutura de referência

O que vem pronto e pode ser usado como está:

- **Esteira**: pesquisa e roteiro → revisão do roteiro → voz e arte em paralelo → storyboard com tempos reais → montagem e render → revisão do corte → entrega → publicação opcional (`modelos/FLUXO.md`).
- **Formatos**: V (veredito sobre um item, 30–40 s), L (lista curta, 35–45 s) e H (história com problema e solução, 45–60 s), sempre com um único fecho de oferta e CTA (`modelos/roteiro-formatos.md`).
- **Perfil técnico**: vertical 1080 × 1920, 30 fps, áudio em −14 LUFS, pico de −1,5 dBTP, AAC 192 kb/s (`config/projeto.exemplo.json`).
- **Perfil visual sugerido**: animação 2D em papel recortado, com rigs vetoriais e movimento em passos de cerca de 12 por segundo (`estudio/REQUISITOS.md`).
- **Controle**: banco com versões vinculadas a cada parecer, estados separados de voz e arte, custos idempotentes e travas de piloto, rotina e publicação (`sql/`).

## O que você configura no setup

| Ponto | Onde fica |
| --- | --- |
| Negócio, público, idioma, oferta, benefícios comprovados e CTA | `config/projeto.json` → `negocio` |
| Fontes de pauta e evidência, com tipo e alcance | `config/projeto.json` → `fontes` e tabela `studio_fontes` |
| Limites editoriais e tratamento de ficção, marcas e preços | `config/projeto.json` → `editorial` e `BIBLIA.md` |
| Estilo, paleta, personagens e vozes | `config/projeto.json` → `visual` |
| Formatos ativos, durações e perfil de vídeo | `config/projeto.json` → `video` |
| Serviços de imagem, voz, transcrição, render e cofre | `config/projeto.json` → `ferramentas` |
| Teto de custo, ritmo, lote, concorrência e rotina | `config/projeto.json` → `operacao` |
| Contas, redes, publicador e autorização | `config/projeto.json` → `publicacao` |

Os prompts não dependem de um provedor específico de IA, voz, render ou agendamento. Escolha os serviços a que você tem acesso. Credenciais ficam no cofre da instalação; o projeto registra apenas o nome da credencial.

## Fontes e evidências

Você pode usar catálogo próprio, planilha, API, documentos, base de conhecimento ou pesquisa pública. Uma opinião sustenta uma recomendação editorial; um manual sustenta uma especificação; alegações de saúde e segurança exigem fonte oficial adequada e atual para o setor e o país. A origem e as condições de uso de cada fonte ficam no registro interno.

## Sobre o SQL e as consultas

Em `sql/`, ficam o esquema e as instruções do controle de produção, em SQLite, com parâmetros nomeados (como `:projeto_id`). Rode `00_schema.sql` em uma base nova ou em um namespace verificado. Os demais arquivos têm instruções independentes: execute uma por chamada e nunca concatene texto de usuário sem escape. Cada instrução tem um código (`CO`, `AR`, `PR` e `RV` para cada papel) usado como referência nos prompts.

Em `consultas/`, "consulta" significa um pedido em linguagem natural a um agente ou um modelo de busca de fontes.

## Estado inicial e travas

O projeto nasce em `setup`, com piloto pendente, rotina desativada e publicação sem autorização. Criar os agentes e as tabelas não prova que o render funciona: o relatório de instalação distingue estrutura criada, fontes testadas, motor validado e piloto aprovado.

Versão do pacote: 1.1.0.

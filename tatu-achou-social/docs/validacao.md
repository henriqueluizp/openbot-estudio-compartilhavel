# Validação do pacote e da instalação

## Revisão documental por agente

| Agente | Veredito documental | Responsabilidade validada e fronteira |
| --- | --- | --- |
| 01 Gestor | Apto | Único contato; distribui, acompanha, coordena correções e entrega; pede autorização diretamente ao proprietário. Não substitui revisão independente. |
| 02 Coordenação | Apto | Conceito, direção narrativa/visual, séries e orientação; execução de peças fica com Design/Reels. |
| 03 Pesquisa | Apto | Tendências e referências com fonte/data, público, motivo, formato e adaptação; hipóteses separadas de evidências. Não define calendário. |
| 04 Estratégia | Apto | Objetivos, jornada, calendário, testes, crescimento e análise mensal com dados reais; não toma direção visual. |
| 05 Design | Apto, produção de mídia bloqueada | Posts, carrosséis, capas, ilustrações, cenários e templates; agora especificações textuais. Preserva mascote oficial, sem chamar prompt de arte final. |
| 06 Reels | Apto, vídeo/voz bloqueados | Gancho, roteiro, storyboard, movimento, som planejado e requisitos técnicos; sem catálogo de preços nem render presumido. |
| 07 Copy | Apto | Textos, títulos, legendas, CTA, hashtags e colaboração de redação no roteiro; não assume montagem nem estratégia. |
| 08 Revisão | Apto | Parecer independente, autoridade de reprovar, evidências e correção pelo autor via Gestor; não aprova mídia ausente nem autoriza publicação. |

Todos os prompts incluem contexto da marca, oito papéis, protocolo de entrega, hierarquia, único contato, restrições e tratamento de ferramentas indisponíveis. Não dependem da leitura de outro prompt para estabelecer essas regras. A colaboração continua condicionada à capacidade real do OpenBot.

## Verificação local

Na raiz do repositório, execute `python3 tatu-achou-social/docs/validar-pacote.py`. A verificação confere JSON, oito agentes exclusivos, caminhos, pastas, inventário, bloqueios, regras autossuficientes, sincronização do texto único e padrões comuns de credenciais. A inspeção textual complementa a busca automatizada; nenhum detector garante ausência universal de segredos.

## Teste obrigatório no OpenBot — ainda pendente

1. Configure os oito prompts e registre nomes reais em uma cópia privada do relatório de instalação. Confirme que somente o Gestor atende ao proprietário.
2. Envie ao Gestor: “Teste textual: planeje um Reel de humor sobre compras por impulso; não gere mídia nem publique”. O Gestor cria uma tarefa com ID, objetivo, dependências, responsáveis, versão e critério de aceite.
3. Pesquisa retorna evidências reais ou limitações; Estratégia retorna objetivo/indicador; Coordenação propõe conceito. Confirme mensagens recebidas, sem aceitar respostas simuladas como prova.
4. Design entrega especificação textual; Reels entrega roteiro/storyboard; Copy entrega legenda. Cada um salva um arquivo de teste em sua pasta. Confirme que o destinatário consegue ler a mesma versão.
5. Revisão analisa os arquivos reais. Inclua deliberadamente uma lista de preços em uma versão de teste: ela deve ser reprovada. Gestor devolve ao autor; Revisão reavalia a versão corrigida.
6. Gestor consolida somente as entregas existentes e registra vídeo/voz indisponíveis, arte final pendente e autorização de publicação ausente. Nenhum especialista solicita aprovação diretamente ao proprietário.
7. Teste falha de acesso a uma pasta ou mensagem: o agente deve comunicar bloqueio, sem alegar entrega. Registre evidências, limitações e procedimentos compatíveis no relatório.

Um teste textual aprovado comprova apenas esse fluxo. Não comprova produção audiovisual, acesso a métricas privadas ou campanha concluída. Pacote validado não significa agentes instalados.

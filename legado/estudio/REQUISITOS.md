# Contrato do estúdio audiovisual

Este documento descreve os arquivos trocados entre os agentes e o que o motor de vídeo precisa fazer. O pacote não inclui código, rigs, vozes nem gravações: a Produção constrói um motor para este contrato ou adapta um motor autorizado existente, e documenta a interface realmente implementada.

## Perfil de referência

A estrutura foi desenhada para este caminho, que pode ser recriado do zero:

| Camada | Referência | Alternativas aceitas |
| --- | --- | --- |
| Composição e render | Remotion (React → MP4) | Qualquer motor que gere os mesmos artefatos, como FFmpeg com scripts, After Effects automatizado ou outro framework de vídeo programático |
| Estilo | Animação 2D em papel recortado, com rigs SVG de peças e pivôs | Ilustração, motion graphics, apresentador ou outro estilo definido no setup |
| Movimento | Em passos, com cerca de 12 poses por segundo dentro de 30 fps, lembrando stop motion | Movimento contínuo ou outro ritmo próprio do estilo |
| Voz | TTS com uma voz por personagem | Locução gravada ou outro serviço de voz |
| Tempos | Transcrição com alinhamento por palavra | Alinhamento forçado ou marcação manual |
| Som e master | Efeitos, trilha e normalização de loudness | Mesmo resultado com outra ferramenta |

Escolha versões disponíveis e compatíveis, confira a documentação e as licenças atuais e registre as dependências. Caminhos de assets são relativos à raiz do projeto; configurações por máquina ficam fora do conteúdo editorial. Não reutilize caminhos absolutos, symlinks, chaves ou contas de outra instalação.

## Entradas

- `config/projeto.json`: dimensões, fps, estilo, personagens, vozes, perfil de áudio e limites.
- `roteiro.md`: texto e identificadores estáveis das falas (`f01`, `f02`, `fecho`).
- `audio/falas/`: tomadas individuais e referência de origem.
- `audio/tempos.json`: versão do roteiro, fala, locutor, arquivo, início, fim e palavras alinhadas, quando disponíveis.
- `storyboard/storyboard.json`: versão, planos, referências de fala, assets e ações (modelo em `modelos/storyboard.json`).
- `montagem.json`: escolhas de edição, transições, textos, destaques e som, vinculadas às versões.

A Arte e a Produção podem adaptar esses schemas no setup. Registrem o contrato acordado e atualizem os modelos juntas antes de usá-lo em lote.

## Capacidades do motor

1. Renderizar planos com personagens, objetos e texto, preservando a proporção e a área legível no celular.
2. Em rigs, animar peças com pivôs consistentes, expressões e boca do locutor; em outros estilos, manter a identidade e a relação entre fala e personagem.
3. No perfil de papel recortado, oferecer o movimento em passos descrito acima. Esse é um parâmetro visual do perfil, não uma obrigação para outros estilos.
4. Usar o áudio real para os tempos, com pronúncia conferida e legenda fiel ao roteiro. Reutilizar falas aprovadas por texto, voz e parâmetros, preservando os direitos de uso.
5. Sincronizar rótulos, contadores, carimbos e efeitos com a fala e a ação. Exibir evidência visual de uma alegação quando o formato exigir.
6. Ter um único bloco de oferta e CTA, quando configurado, sem componentes que o dupliquem.
7. Conferir referências e versões antes de renderizar; falhar de forma explicável se faltar asset, áudio ou aprovação.
8. Controlar concorrência e temporários. Segredos são obtidos por referência ao cofre e não entram em código versionado, montagem ou relatório.

## Saídas

- `final/vN.mp4`: vídeo reproduzível no perfil configurado.
- `contact.jpg`: um quadro por segundo, para localizar planos e defeitos.
- `producao.md`: versões, medições, comandos, conferências, créditos e custos.
- Registro de cada operação paga, com chave idempotente.

O perfil técnico padrão é 1080 × 1920, 30 fps, áudio próximo de −14 LUFS, pico máximo de −1,5 dBTP e AAC 192 kb/s. Cada destino pode exigir outra configuração; confira no setup. Remova campos pessoais de autoria ou localização, preservando os dados técnicos e a sinalização de mídia sintética exigidos pela plataforma.

## Validação mínima

Antes do piloto editorial, renderize um teste curto com assets próprios, áudio e legenda. Abra o MP4 e confira duração, resolução, áudio e sincronismo. Typecheck ou a simples existência do arquivo não provam o render.

Depois, produza o piloto com o fluxo completo: roteiro revisado, voz, storyboard, corte e parecer final. Registre no relatório duas situações separadas: motor validado e piloto editorial aprovado pelo responsável. Só a segunda libera a mudança de fase.

## Comandos a documentar

O motor deve oferecer e documentar as ações de: preparar voz sem gastar (simulação), gerar voz, montar, conferir, renderizar e exportar o pacote. Registre em `estudio/README.md` os comandos reais que a Produção implementar.

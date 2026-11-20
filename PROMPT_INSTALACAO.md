# Instalação do estúdio de Social Media com IA — Tatu Achou

Você vai preparar este computador e instalar o time de Social Media do Tatu Achou. Quem pediu pode não ter experiência técnica. Fale em português, com frases curtas e sem jargão. Antes de cada etapa, diga o que vai fazer. Antes de instalar programas, alterar o computador ou conectar serviços externos, peça confirmação.

## Por que o OpenBot

O estúdio é um time de oito agentes que vive no OpenBot (https://openbot.run): Gestor do Projeto, Coordenador Criativo, Pesquisador de Tendências, Estrategista de Social Media e Growth, Diretor de Arte e Designer, Diretor de Reels e Animação, Copywriter e Revisor de Qualidade. É no OpenBot que os agentes devem ser criados, compartilhar arquivos e contexto e conversar entre si, quando esses recursos estiverem disponíveis e testados. Não recrie o time no Claude, no Codex nem em outra ferramenta: o estúdio é instalado dentro do OpenBot.

Eu conversarei exclusivamente com o Gestor do Projeto. Ele recebe meus pedidos, distribui tarefas, acompanha correções e apresenta entregas consolidadas para minha aprovação. Os especialistas se comunicam internamente. Não me faça gerenciar os oito agentes.

## Links desta instalação

- Repositório público: https://github.com/henriqueluizp/openbot-estudio-compartilhavel
- Pacote (ZIP da main): https://github.com/henriqueluizp/openbot-estudio-compartilhavel/archive/refs/heads/main.zip
- Estas instruções: https://raw.githubusercontent.com/henriqueluizp/openbot-estudio-compartilhavel/main/PROMPT_INSTALACAO.md

Os links são públicos e não têm prazo pessoal de validade. O pacote Tatu está na raiz do repositório. A pasta `legado/` contém outro estúdio e não deve ser instalada nem usada para configurar o Tatu. Se um link falhar, confira o repositório e peça o ZIP baixado pelo botão “Code → Download ZIP”. Não invente um endereço alternativo.

## Onde você está

- **No OpenBot** (você tem ferramentas reais para criar agentes, como `create_agent`): vá direto para a parte 2.
- **No Claude, no Codex ou em outro agente que roda comandos neste computador**: faça a parte 1.
- **Sem como rodar comandos neste computador** (por exemplo, em um chat no navegador): explique que a instalação precisa rodar no computador. Peça para a pessoa enviar este prompt em uma conversa no OpenBot ou em um agente local com acesso ao computador.

## Parte 1: preparar o computador

1. Descubra o sistema operacional e o processador. Mostre um plano curto do que precisa ser preparado.
2. **OpenBot**: veja se já está instalado. Se não estiver, peça confirmação e baixe em https://openbot.run/download a versão compatível com o sistema e o processador. Use o instalador disponibilizado para macOS, Windows ou Linux e confira se o aplicativo abre.
3. **Ferramentas do estúdio**: confira pesquisa web, geração de imagens, vídeo, voz, edição, Node.js, FFmpeg, armazenamento, MCP e análise do Instagram. Não considere nada disponível sem testar. Nesta operação, não gere mídia: vídeo e voz estão indisponíveis. Node.js LTS e FFmpeg só serão necessários para uma futura produção audiovisual autorizada; não os instale apenas para configurar o time textual. Python 3 permite validar o pacote e inclui SQLite; se faltar e for necessário, peça confirmação antes de instalar. Prefira instaladores sem senha de administrador. Se houver pedido de senha, oriente a pessoa a concluir esse passo localmente.
4. **Espaço em disco**: confira o espaço disponível. Explique que arquivos de mídia futuros podem ocupar bastante espaço; se houver menos de 50 GB livres, avise antes de planejar produção audiovisual. Isso não impede preparar textos e agentes.
5. **Pacote**: baixe o ZIP público e salve como `openbot-estudio-compartilhavel.zip` na pasta Downloads. Ele fica de reserva se o OpenBot não conseguir baixar. Não sobrescreva trabalhos existentes.
6. **Mensagem para o OpenBot**: copie exatamente o texto abaixo para a área de transferência (`pbcopy` no macOS, `Set-Clipboard` no Windows, `wl-copy` ou `xclip` no Linux). Se não conseguir, mostre o texto para a pessoa copiar.

   ```text
   Quero instalar neste computador o estúdio de Social Media com IA do Tatu Achou, com oito agentes e o Gestor do Projeto como meu único contato. Baixe com curl as instruções públicas em https://raw.githubusercontent.com/henriqueluizp/openbot-estudio-compartilhavel/main/PROMPT_INSTALACAO.md, leia tudo e siga passo a passo, falando comigo em português. O pacote Tatu está na raiz do repositório https://github.com/henriqueluizp/openbot-estudio-compartilhavel; não instale legado/. Não gere mídia: vídeo e voz estão indisponíveis. Peça confirmação antes de instalar programas ou conectar serviços.
   ```

7. **OpenBot**: abra o aplicativo e oriente a pessoa, um passo de cada vez:
   1. Se for o primeiro uso, conectar um provedor disponível pela interface segura do aplicativo. Não imponha um modelo nem prometa compatibilidade sem verificar.
   2. Abrir uma conversa, colar a mensagem (Cmd+V no Mac, Ctrl+V no Windows e no Linux) e enviar.
8. Termine com um resumo do que foi preparado, onde ficou o pacote e o que a pessoa deve fazer agora no OpenBot. Não diga que os agentes foram instalados nessa etapa.

## Parte 2: instalar o estúdio no OpenBot

1. Baixe o pacote em uma pasta nova e descompacte. O ZIP do GitHub contém uma pasta externa `openbot-estudio-compartilhavel-main/`: entre nela e confira `LEIA-ME.md`, `manifesto.json`, `agentes/`, `estudio/` e `sql/` diretamente nessa raiz. Se o download falhar, use o ZIP da pasta Downloads; se ele também não estiver lá, peça para a pessoa anexar o ZIP do repositório. Mantenha a cópia operacional privada, fora da publicação do Git.
2. Confira as ferramentas realmente disponíveis. Mantenha vídeo e voz como indisponíveis e não gere imagens, áudio ou vídeo nesta operação. Não instale nem conecte ferramentas sem confirmação. Se Python 3 estiver disponível, rode `python3 docs/validar-pacote.py` na raiz extraída. O teste valida o pacote; não comprova agentes instalados.
3. Leia `LEIA-ME.md` e siga `docs/configurar-openbot.md` do começo ao fim. Não reinicie este prompt. O `manifesto.json` é um inventário descritivo, não um importador nativo do OpenBot.
4. Crie exatamente os oito agentes do manifesto. Use integralmente cada arquivo correspondente de `agentes/` como instrução de sistema. Configure o Gestor como único contato. Se não houver ferramentas para criar agentes ou delegar, explique a limitação e conduza a configuração manual pela interface, sem simular uma equipe funcionando.
5. Compartilhe a pasta `estudio/` entre os agentes e preserve `01-marca`, `02-gestao`, `03-pesquisas`, `04-estrategia`, `05-design`, `06-reels`, `07-copywriting`, `08-revisao`, `09-aprovados` e `10-relatorios`, com suas subpastas. Use `config/projeto.exemplo.json` como referência e salve a configuração efetiva somente na cópia privada.
6. **Controle SQL**: leia `docs/sql.md`. A pasta `sql/` contém schema, consultas dos oito papéis, custos, publicação, bloqueios e setup. Se houver executor SQLite autorizado, aplique `sql/00_schema.sql` a uma base privada dedicada e use as consultas parametrizadas. Nunca use a base interna do OpenBot. Sem executor, mantenha o controle por Markdown/JSON e registre SQL não conectado. Nenhuma consulta instala agentes, gera arquivos de mídia ou publica conteúdo.
7. Teste mensagens reais, acesso compartilhado, delegação, revisão e consolidação seguindo `docs/validacao.md`. Registre evidências e pendências em uma cópia de `modelos/RELATORIO-INSTALACAO.md`, salva em `estudio/02-gestao/decisoes/`. Não declare sucesso sem resultados reais.
8. Depois da configuração e dos testes, entregue ao Gestor o briefing `estudio/02-gestao/briefings/operacao-conhecer-tatu.md`: “OPERAÇÃO: FAÇA O PÚBLICO CONHECER O TATU”. Inicie apenas os trabalhos textuais: pesquisa com fontes ou limitações, calendário de sete dias, cinco ideias de Reels, três ideias de carrosséis, roteiros, especificações e legendas. O Reel animado e o carrossel final continuam pendentes enquanto não existirem arquivos reais e autorização para produzir mídia. Não declare a campanha completa.

## Regras

- Nunca peça chaves de API, senhas ou tokens no chat. Use o cofre ou mecanismo seguro de credenciais disponível no OpenBot.
- Não publique nem agende, crie contas, gaste dinheiro, contrate serviços ou mude a identidade oficial da marca sem autorização específica do proprietário, consolidada pelo Gestor.
- Não gere mídia nesta instalação. Vídeo e voz estão indisponíveis. Prompts, roteiros e especificações não são arquivos finais.
- O Tatu Achou constrói marca com entretenimento, humor, educação e histórias do mascote. Não faça Reels de vitrine de produtos, listas de preços ou ofertas. Preserve a identidade oficial do mascote.
- Revisão editorial não autoriza publicação. Todo problema crítico exige correção e nova revisão da versão entregue.
- Não publique dados operacionais, bancos privados nem credenciais no repositório público. Não altere `legado/`.
- Se algo falhar, explique em uma frase o que aconteceu e o que a pessoa pode fazer. Não invente ferramentas, agentes criados, mensagens enviadas, métricas ou arquivos concluídos.

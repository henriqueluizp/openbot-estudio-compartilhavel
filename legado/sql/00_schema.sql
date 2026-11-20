-- Banco de controle do conteúdo. SQLite com suporte a JSON.
-- Executar somente em base própria ou namespace conferido. Não usar o banco interno do OpenBot.
-- Em ferramentas que aceitam uma instrução por chamada, enviar cada instrução separadamente.
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS studio_projetos (
  projeto_id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  estado TEXT NOT NULL DEFAULT 'setup' CHECK (estado IN ('setup','piloto','ativo','pausado')),
  piloto_aprovado INTEGER NOT NULL DEFAULT 0 CHECK (piloto_aprovado IN (0,1)),
  rotina_ativa INTEGER NOT NULL DEFAULT 0 CHECK (rotina_ativa IN (0,1)),
  publicacao_autorizada INTEGER NOT NULL DEFAULT 0 CHECK (publicacao_autorizada IN (0,1)),
  autorizacao_ref TEXT,
  conta_confirmada INTEGER NOT NULL DEFAULT 0 CHECK (conta_confirmada IN (0,1)),
  teto_usd_por_episodio REAL CHECK (teto_usd_por_episodio >= 0),
  config_json TEXT NOT NULL DEFAULT '{}' CHECK (json_valid(config_json)),
  atualizado_em TEXT NOT NULL DEFAULT (datetime('now')),
  CHECK (estado <> 'ativo' OR piloto_aprovado = 1),
  CHECK (rotina_ativa = 0 OR (estado = 'ativo' AND piloto_aprovado = 1)),
  CHECK (publicacao_autorizada = 0 OR COALESCE(length(trim(autorizacao_ref)),0) > 0)
);

CREATE TABLE IF NOT EXISTS studio_fontes (
  projeto_id TEXT NOT NULL REFERENCES studio_projetos(projeto_id),
  chave TEXT NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('catalogo','opiniao','tecnica','oficial','referencia_visual')),
  titulo TEXT NOT NULL,
  referencia TEXT NOT NULL,
  autoria TEXT,
  uso_permitido TEXT,
  sustenta TEXT NOT NULL,
  limitacoes TEXT,
  leitura_testada INTEGER NOT NULL DEFAULT 0 CHECK (leitura_testada IN (0,1)),
  conferida_em TEXT,
  PRIMARY KEY (projeto_id, chave)
);

CREATE TABLE IF NOT EXISTS studio_temas (
  projeto_id TEXT NOT NULL REFERENCES studio_projetos(projeto_id),
  slug TEXT NOT NULL,
  titulo TEXT NOT NULL,
  categoria TEXT,
  item TEXT,
  angulo TEXT,
  veredito_editorial TEXT,
  fontes_json TEXT NOT NULL DEFAULT '[]' CHECK (json_valid(fontes_json)),
  riscos TEXT,
  ficha TEXT,
  status TEXT NOT NULL DEFAULT 'proposto' CHECK (status IN ('proposto','pesquisado','aprovado','usado','vetado')),
  atualizado_em TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (projeto_id, slug)
);

CREATE TABLE IF NOT EXISTS studio_episodios (
  id INTEGER PRIMARY KEY,
  projeto_id TEXT NOT NULL REFERENCES studio_projetos(projeto_id),
  slug TEXT NOT NULL,
  titulo TEXT NOT NULL,
  tema_slug TEXT,
  formato TEXT NOT NULL,
  lote TEXT,
  piloto INTEGER NOT NULL DEFAULT 0 CHECK (piloto IN (0,1)),
  etapa TEXT NOT NULL DEFAULT 'pauta' CHECK (etapa IN ('pauta','pesquisa','roteiro','revisao_roteiro','ajuste_roteiro','producao','revisao_final','aprovado','pronto','publicado','bloqueado','pausado','vetado')),
  responsavel TEXT NOT NULL DEFAULT 'coordenacao',
  pasta TEXT NOT NULL,
  roteiro_versao INTEGER NOT NULL DEFAULT 1 CHECK (roteiro_versao >= 1),
  roteiro_revisado_versao INTEGER,
  roteiro_veredito TEXT CHECK (roteiro_veredito IN ('APROVADO','APROVADO COM AJUSTE','REPROVADO','BLOQUEADO')),
  ajuste_exato_aplicado INTEGER NOT NULL DEFAULT 0 CHECK (ajuste_exato_aplicado IN (0,1)),
  ajuste_descricao TEXT,
  estado_voz TEXT NOT NULL DEFAULT 'pendente' CHECK (estado_voz IN ('pendente','em_andamento','pronto','bloqueado')),
  voz_roteiro_versao INTEGER,
  estado_arte TEXT NOT NULL DEFAULT 'pendente' CHECK (estado_arte IN ('pendente','em_andamento','pronto','bloqueado')),
  arte_roteiro_versao INTEGER,
  arte_versao INTEGER NOT NULL DEFAULT 0 CHECK (arte_versao >= 0),
  video_versao INTEGER NOT NULL DEFAULT 0 CHECK (video_versao >= 0),
  video_roteiro_versao INTEGER,
  video_arte_versao INTEGER,
  video_arquivo TEXT,
  final_revisado_versao INTEGER,
  final_veredito TEXT CHECK (final_veredito IN ('APROVADO','REPROVADO','BLOQUEADO')),
  rodadas_final INTEGER NOT NULL DEFAULT 0 CHECK (rodadas_final >= 0),
  duracao_s REAL CHECK (duracao_s > 0),
  bloqueio TEXT,
  notas TEXT,
  criado_em TEXT NOT NULL DEFAULT (datetime('now')),
  atualizado_em TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (projeto_id, slug),
  FOREIGN KEY (projeto_id, tema_slug) REFERENCES studio_temas(projeto_id, slug)
);

CREATE TABLE IF NOT EXISTS studio_custos (
  id INTEGER PRIMARY KEY,
  projeto_id TEXT NOT NULL,
  episodio_slug TEXT NOT NULL,
  chave TEXT NOT NULL,
  agente TEXT NOT NULL,
  etapa TEXT NOT NULL,
  servico TEXT NOT NULL,
  modelo TEXT,
  unidade TEXT,
  quantidade REAL CHECK (quantidade >= 0),
  custo_usd REAL CHECK (custo_usd >= 0),
  medido INTEGER NOT NULL DEFAULT 0 CHECK (medido IN (0,1)),
  nota TEXT,
  criado_em TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (projeto_id, chave),
  FOREIGN KEY (projeto_id, episodio_slug) REFERENCES studio_episodios(projeto_id, slug),
  CHECK (medido = 0 OR custo_usd IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS studio_publicacoes (
  id INTEGER PRIMARY KEY,
  projeto_id TEXT NOT NULL,
  episodio_slug TEXT NOT NULL,
  video_versao INTEGER NOT NULL,
  conta TEXT NOT NULL,
  rede TEXT NOT NULL,
  pacote TEXT NOT NULL,
  estado TEXT NOT NULL DEFAULT 'preparado' CHECK (estado IN ('preparado','enviado','agendado','publicado','falhou')),
  autorizacao_ref TEXT,
  recibo_externo TEXT,
  link TEXT,
  publicado_em TEXT,
  atualizado_em TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (projeto_id, episodio_slug, video_versao, conta, rede),
  FOREIGN KEY (projeto_id, episodio_slug) REFERENCES studio_episodios(projeto_id, slug)
);

CREATE INDEX IF NOT EXISTS studio_episodios_fila ON studio_episodios(projeto_id, etapa, atualizado_em);

CREATE VIEW IF NOT EXISTS studio_fila AS
SELECT e.*, p.estado AS estado_projeto, p.piloto_aprovado, p.rotina_ativa,
  p.publicacao_autorizada, p.conta_confirmada, p.autorizacao_ref,
  p.teto_usd_por_episodio,
  CASE WHEN (p.estado = 'ativo' AND p.piloto_aprovado = 1)
    OR (p.estado = 'piloto' AND e.piloto = 1) THEN 1 ELSE 0 END AS pode_produzir,
  CASE WHEN (e.roteiro_veredito = 'APROVADO' AND e.roteiro_revisado_versao = e.roteiro_versao)
    OR (e.roteiro_veredito = 'APROVADO COM AJUSTE' AND e.ajuste_exato_aplicado = 1
      AND e.roteiro_revisado_versao = e.roteiro_versao - 1 AND length(trim(e.ajuste_descricao)) > 0)
    THEN 1 ELSE 0 END AS roteiro_liberado,
  CASE WHEN e.final_veredito = 'APROVADO' AND e.video_versao > 0
    AND e.final_revisado_versao = e.video_versao
    AND e.video_roteiro_versao = e.roteiro_versao
    AND e.video_arte_versao = e.arte_versao
    AND e.voz_roteiro_versao = e.roteiro_versao
    AND e.arte_roteiro_versao = e.roteiro_versao
    AND e.estado_voz = 'pronto' AND e.estado_arte = 'pronto'
    THEN 1 ELSE 0 END AS final_liberado,
  c.valor_registrado_usd, c.valor_medido_usd,
  COALESCE(c.registros_custo, 0) AS registros_custo,
  COALESCE(c.nao_medidos, 0) AS custos_nao_medidos,
  COALESCE(c.sem_valor_usd, 0) AS custos_sem_valor_usd
FROM studio_episodios e
JOIN studio_projetos p ON p.projeto_id = e.projeto_id
LEFT JOIN (
  SELECT projeto_id, episodio_slug, SUM(custo_usd) AS valor_registrado_usd,
    SUM(CASE WHEN medido = 1 THEN custo_usd END) AS valor_medido_usd,
    COUNT(*) AS registros_custo,
    SUM(CASE WHEN medido = 0 THEN 1 ELSE 0 END) AS nao_medidos,
    SUM(CASE WHEN custo_usd IS NULL THEN 1 ELSE 0 END) AS sem_valor_usd
  FROM studio_custos GROUP BY projeto_id, episodio_slug
) c ON c.projeto_id = e.projeto_id AND c.episodio_slug = e.slug;

-- SQLite. Base privada dedicada ao Tatu, nunca o banco interno do OpenBot.
-- Ative foreign_keys em CADA conexão. Schema idempotente, sem credenciais.
PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS tatu_projetos (
  projeto_id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  estado TEXT NOT NULL DEFAULT 'setup' CHECK (estado IN ('setup','textual','pausado')),
  evidencia_setup TEXT,
  midia_autorizada INTEGER NOT NULL DEFAULT 0 CHECK (midia_autorizada=0),
  video_disponivel INTEGER NOT NULL DEFAULT 0 CHECK (video_disponivel=0),
  voz_disponivel INTEGER NOT NULL DEFAULT 0 CHECK (voz_disponivel=0)
);
CREATE TABLE IF NOT EXISTS tatu_agentes (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  pasta TEXT NOT NULL UNIQUE
);
INSERT OR IGNORE INTO tatu_agentes VALUES
 ('01','Gestor do Projeto','estudio/02-gestao'),
 ('02','Coordenador Criativo','estudio/04-estrategia/campanhas'),
 ('03','Pesquisador de Tendências','estudio/03-pesquisas'),
 ('04','Estrategista de Social Media e Growth','estudio/04-estrategia/calendario-editorial'),
 ('05','Diretor de Arte e Designer','estudio/05-design'),
 ('06','Diretor de Reels e Animação','estudio/06-reels'),
 ('07','Copywriter','estudio/07-copywriting'),
 ('08','Revisor de Qualidade','estudio/08-revisao');
CREATE TABLE IF NOT EXISTS tatu_tarefas (
  projeto_id TEXT NOT NULL REFERENCES tatu_projetos(projeto_id),
  tarefa_id TEXT NOT NULL,
  pedido TEXT NOT NULL,
  objetivo TEXT NOT NULL,
  agente TEXT NOT NULL REFERENCES tatu_agentes(id),
  pasta TEXT NOT NULL CHECK (pasta LIKE 'estudio/%' AND instr(pasta,'..')=0),
  criterio TEXT NOT NULL,
  versao INTEGER NOT NULL DEFAULT 1 CHECK (versao>0),
  estado TEXT NOT NULL DEFAULT 'planejado' CHECK (estado IN
    ('planejado','em_execucao','em_revisao','em_ajustes','revisado','bloqueado')),
  bloqueio TEXT,
  nota TEXT,
  atualizado_em TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (projeto_id,tarefa_id)
);
CREATE TABLE IF NOT EXISTS tatu_entregas (
  projeto_id TEXT NOT NULL,
  tarefa_id TEXT NOT NULL,
  versao INTEGER NOT NULL CHECK (versao>0),
  arquivo TEXT NOT NULL CHECK (arquivo LIKE 'estudio/%' AND instr(arquivo,'..')=0),
  resumo TEXT NOT NULL CHECK (length(trim(resumo))>0),
  criado_em TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (projeto_id,tarefa_id,versao),
  FOREIGN KEY (projeto_id,tarefa_id) REFERENCES tatu_tarefas(projeto_id,tarefa_id)
);
CREATE TABLE IF NOT EXISTS tatu_revisoes (
  projeto_id TEXT NOT NULL,
  tarefa_id TEXT NOT NULL,
  versao INTEGER NOT NULL,
  veredito TEXT NOT NULL CHECK (veredito IN ('aprovado','aprovado_com_ajustes','reprovado','bloqueado')),
  parecer TEXT NOT NULL CHECK (parecer LIKE 'estudio/08-revisao/%'),
  criado_em TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (projeto_id,tarefa_id,versao),
  FOREIGN KEY (projeto_id,tarefa_id,versao) REFERENCES tatu_entregas(projeto_id,tarefa_id,versao)
);
CREATE TRIGGER IF NOT EXISTS tatu_entrega_estado AFTER INSERT ON tatu_entregas
BEGIN
  UPDATE tatu_tarefas SET estado='em_revisao',atualizado_em=datetime('now')
  WHERE projeto_id=NEW.projeto_id AND tarefa_id=NEW.tarefa_id AND versao=NEW.versao;
END;
CREATE TRIGGER IF NOT EXISTS tatu_revisao_estado AFTER INSERT ON tatu_revisoes
BEGIN
  UPDATE tatu_tarefas SET estado=CASE NEW.veredito WHEN 'aprovado' THEN 'revisado'
    WHEN 'bloqueado' THEN 'bloqueado' ELSE 'em_ajustes' END,
    bloqueio=CASE WHEN NEW.veredito='bloqueado' THEN NEW.parecer ELSE NULL END,
    atualizado_em=datetime('now')
  WHERE projeto_id=NEW.projeto_id AND tarefa_id=NEW.tarefa_id AND versao=NEW.versao;
END;
CREATE TABLE IF NOT EXISTS tatu_custos (
  projeto_id TEXT NOT NULL,
  tarefa_id TEXT NOT NULL,
  chave TEXT NOT NULL,
  agente TEXT NOT NULL REFERENCES tatu_agentes(id),
  servico TEXT NOT NULL,
  valor REAL CHECK (valor>=0),
  medido INTEGER NOT NULL CHECK (medido IN (0,1) AND (medido=0 OR valor IS NOT NULL)),
  autorizacao_ref TEXT,
  PRIMARY KEY (projeto_id,chave),
  FOREIGN KEY (projeto_id,tarefa_id) REFERENCES tatu_tarefas(projeto_id,tarefa_id)
);
CREATE TABLE IF NOT EXISTS tatu_publicacoes (
  projeto_id TEXT NOT NULL,
  tarefa_id TEXT NOT NULL,
  versao INTEGER NOT NULL,
  conta TEXT NOT NULL CHECK (length(trim(conta))>0),
  autorizacao_ref TEXT NOT NULL CHECK (autorizacao_ref LIKE 'estudio/02-gestao/aprovacoes/%'),
  estado TEXT NOT NULL DEFAULT 'autorizado' CHECK (estado IN ('autorizado','agendado','publicado','falhou','revogado')),
  recibo TEXT,
  link TEXT,
  PRIMARY KEY (projeto_id,tarefa_id,versao,conta),
  FOREIGN KEY (projeto_id,tarefa_id,versao) REFERENCES tatu_entregas(projeto_id,tarefa_id,versao)
);
CREATE VIEW IF NOT EXISTS tatu_fila AS
SELECT t.*,p.estado AS estado_projeto,e.arquivo,e.resumo,r.veredito,r.parecer
FROM tatu_tarefas t JOIN tatu_projetos p USING (projeto_id)
LEFT JOIN tatu_entregas e USING (projeto_id,tarefa_id,versao)
LEFT JOIN tatu_revisoes r USING (projeto_id,tarefa_id,versao);

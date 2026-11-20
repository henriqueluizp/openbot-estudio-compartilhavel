-- ADMINISTRAÇÃO: instalador/responsável. Os agentes de produção não se autoautorizam.
-- Criar configuração inicial sem importar aprovação ou autorização de outro projeto.
INSERT INTO studio_projetos (projeto_id,nome,config_json)
VALUES (:projeto_id,:nome,:config_json) ON CONFLICT (projeto_id) DO NOTHING;

-- Liberar piloto específico após o setup e a definição de seu orçamento.
UPDATE studio_projetos SET estado='piloto',teto_usd_por_episodio=:teto_usd_por_episodio,
  atualizado_em=datetime('now') WHERE projeto_id=:projeto_id AND estado='setup';

-- ATIVAÇÃO: executar somente com aprovação do piloto registrada no contexto do projeto.
-- :config_json deve conter a referência dessa aprovação. Não ativa rotina nem publicação.
UPDATE studio_projetos SET piloto_aprovado=1,estado='ativo',config_json=:config_json,
  atualizado_em=datetime('now') WHERE projeto_id=:projeto_id AND estado='piloto';

-- PAUSA: desligar também a rotina nativa, usando as ferramentas do OpenBot.
-- Preservar etapas por episódio para permitir retomada consciente.
UPDATE studio_projetos SET estado='pausado',rotina_ativa=0,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id;

-- RETOMADA: só com instrução do responsável. Rotina continua desligada.
UPDATE studio_projetos SET estado=CASE WHEN piloto_aprovado=1 THEN 'ativo' ELSE 'piloto' END,
  atualizado_em=datetime('now') WHERE projeto_id=:projeto_id AND estado='pausado';

-- ROTINA: registrar autorização já obtida e ativar também a rotina nativa correspondente.
UPDATE studio_projetos SET rotina_ativa=:rotina_ativa,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND estado='ativo' AND piloto_aprovado=1;

-- PUBLICAÇÃO: executar só após conferir autorização, escopo e conta real no setup.
-- Essa configuração não publica arquivos e não cria uma credencial de acesso.
UPDATE studio_projetos SET publicacao_autorizada=:publicacao_autorizada,
  autorizacao_ref=:autorizacao_ref,conta_confirmada=:conta_confirmada,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id;

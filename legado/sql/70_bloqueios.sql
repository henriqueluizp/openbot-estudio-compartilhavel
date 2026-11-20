-- Qualquer papel: registrar bloqueio real, com motivo e ação necessária.
-- Antes de executar, guardar no status do episódio a etapa e o responsável anteriores.
UPDATE studio_episodios SET etapa='bloqueado',responsavel='coordenacao',bloqueio=:motivo,
  notas=:acao_necessaria,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND etapa NOT IN ('publicado','vetado','bloqueado');

-- Coordenação: liberar após a causa ser resolvida. :etapa_retomada vem do status preservado.
-- Mudança de roteiro usa CO07 e nova revisão; não usar a retomada para ignorar parecer.
UPDATE studio_episodios SET etapa=:etapa_retomada,responsavel=:responsavel,bloqueio=NULL,
  notas=:nota_resolucao,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND etapa='bloqueado'
  AND :etapa_retomada IN ('pesquisa','roteiro','revisao_roteiro','ajuste_roteiro','producao','revisao_final')
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1);

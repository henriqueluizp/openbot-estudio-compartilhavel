-- RV01: fila de revisão. O parecer deve identificar a versão examinada.
SELECT slug,titulo,pasta,etapa,roteiro_versao,video_versao,video_arquivo,rodadas_final
FROM studio_fila WHERE projeto_id=:projeto_id AND pode_produzir=1
  AND etapa IN ('revisao_roteiro','revisao_final') ORDER BY criado_em;

-- RV02: registrar revisão de roteiro. :veredito assume os quatro valores documentados.
UPDATE studio_episodios SET roteiro_veredito=:veredito,roteiro_revisado_versao=roteiro_versao,
  etapa=CASE :veredito WHEN 'APROVADO' THEN 'producao'
    WHEN 'APROVADO COM AJUSTE' THEN 'ajuste_roteiro'
    WHEN 'REPROVADO' THEN 'roteiro' ELSE 'bloqueado' END,
  responsavel=CASE :veredito WHEN 'APROVADO' THEN 'producao' ELSE 'coordenacao' END,
  bloqueio=CASE WHEN :veredito='BLOQUEADO' THEN :motivo ELSE NULL END,
  notas=:parecer,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa='revisao_roteiro'
  AND :veredito IN ('APROVADO','APROVADO COM AJUSTE','REPROVADO','BLOQUEADO')
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1);

-- RV03: registrar revisão final. Execução repetida da mesma entrega não conta nova rodada.
-- Ao reprovar, a Produção coordena a correção técnica; problema editorial vai à Coordenação e usa CO07.
UPDATE studio_episodios SET final_veredito=:veredito,final_revisado_versao=video_versao,
  rodadas_final=rodadas_final+1,
  etapa=CASE :veredito WHEN 'APROVADO' THEN 'aprovado'
    WHEN 'REPROVADO' THEN 'producao' ELSE 'bloqueado' END,
  responsavel=CASE :veredito WHEN 'REPROVADO' THEN 'producao' ELSE 'coordenacao' END,
  bloqueio=CASE WHEN :veredito='BLOQUEADO' THEN :motivo ELSE NULL END,
  notas=:parecer,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND video_versao=:video_versao
  AND video_versao>0 AND etapa='revisao_final'
  AND :veredito IN ('APROVADO','REPROVADO','BLOQUEADO')
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1
    AND video_roteiro_versao=roteiro_versao AND video_arte_versao=arte_versao
    AND estado_voz='pronto' AND estado_arte='pronto'
    AND voz_roteiro_versao=roteiro_versao AND arte_roteiro_versao=roteiro_versao);

-- RV04: problemas após duas rodadas; escalar em vez de aprovar automaticamente.
SELECT slug,video_versao,final_veredito,rodadas_final,notas
FROM studio_fila WHERE projeto_id=:projeto_id AND rodadas_final>=2
  AND final_liberado=0 AND etapa NOT IN ('publicado','vetado') ORDER BY atualizado_em;

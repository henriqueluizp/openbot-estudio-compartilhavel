-- PR01: fila de voz. Consultar orçamento com 50_custos.sql antes de chamada paga.
SELECT slug,titulo,pasta,roteiro_versao,estado_voz,teto_usd_por_episodio,valor_registrado_usd
FROM studio_fila WHERE projeto_id=:projeto_id AND pode_produzir=1
  AND roteiro_liberado=1 AND etapa='producao' AND estado_voz IN ('pendente','em_andamento')
ORDER BY criado_em;

-- PR02: iniciar voz da versão esperada.
UPDATE studio_episodios SET estado_voz='em_andamento',atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa='producao' AND estado_voz='pendente'
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

-- PR03: voz conferida e arquivos de tempos entregues à Arte.
UPDATE studio_episodios SET estado_voz='pronto',voz_roteiro_versao=roteiro_versao,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa='producao' AND estado_voz='em_andamento'
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

-- PR04: fila de montagem e correção. Confirmar os arquivos e suas versões antes do render.
SELECT slug,pasta,roteiro_versao,arte_versao,video_versao,final_veredito,rodadas_final
FROM studio_fila WHERE projeto_id=:projeto_id AND pode_produzir=1
  AND roteiro_liberado=1 AND etapa='producao'
  AND estado_voz='pronto' AND voz_roteiro_versao=roteiro_versao
  AND estado_arte='pronto' AND arte_roteiro_versao=roteiro_versao
ORDER BY criado_em;

-- PR05: registrar arquivo realmente exportado. :video_versao_anterior protege contra repetição.
UPDATE studio_episodios SET video_versao=video_versao+1,
  video_roteiro_versao=roteiro_versao,video_arte_versao=arte_versao,
  video_arquivo=:video_arquivo,duracao_s=:duracao_s,
  etapa='revisao_final',responsavel='revisao',final_veredito=NULL,final_revisado_versao=NULL,
  atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND video_versao=:video_versao_anterior
  AND roteiro_versao=:roteiro_versao AND arte_versao=:arte_versao
  AND etapa='producao' AND estado_voz='pronto' AND estado_arte='pronto'
  AND voz_roteiro_versao=roteiro_versao AND arte_roteiro_versao=roteiro_versao
  AND length(trim(:video_arquivo))>0 AND :duracao_s>0
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

-- PR06: refazer áudio mantendo o texto. Tempos e storyboard precisam ser conferidos novamente.
-- Esta instrução só abre a correção; PR02 inicia a nova voz depois da conferência de orçamento.
UPDATE studio_episodios SET estado_voz='pendente',voz_roteiro_versao=NULL,
  estado_arte='pendente',arte_roteiro_versao=NULL,final_veredito=NULL,final_revisado_versao=NULL,
  etapa='producao',notas=:nota_correcao,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa IN ('producao','revisao_final','aprovado')
  AND estado_voz='pronto'
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

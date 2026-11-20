-- AR01: fila de arte; preparação pode ocorrer enquanto a voz é feita.
SELECT slug,titulo,pasta,roteiro_versao,estado_voz,voz_roteiro_versao,estado_arte
FROM studio_fila WHERE projeto_id=:projeto_id AND pode_produzir=1
  AND roteiro_liberado=1 AND etapa='producao' AND estado_arte IN ('pendente','em_andamento')
ORDER BY criado_em;

-- AR02: assumir preparação dos assets.
UPDATE studio_episodios SET estado_arte='em_andamento',atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND estado_arte='pendente' AND etapa='producao'
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

-- AR03: storyboard final já conferido, sincronizado com os tempos da versão atual da voz.
UPDATE studio_episodios SET estado_arte='pronto',arte_roteiro_versao=roteiro_versao,
  arte_versao=arte_versao+1,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND estado_arte='em_andamento' AND etapa='producao'
  AND estado_voz='pronto' AND voz_roteiro_versao=roteiro_versao
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

-- AR04: abrir correção de arte sem mudar o roteiro. A revisão final anterior perde a validade.
UPDATE studio_episodios SET estado_arte='em_andamento',etapa='producao',
  final_veredito=NULL,final_revisado_versao=NULL,notas=:nota_correcao,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND arte_versao=:arte_versao
  AND etapa IN ('producao','revisao_final','aprovado')
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1 AND roteiro_liberado=1);

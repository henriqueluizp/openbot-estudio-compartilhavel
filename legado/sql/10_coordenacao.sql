-- CO01: estado e permissões do projeto antes de produzir.
SELECT projeto_id,nome,estado,piloto_aprovado,rotina_ativa,publicacao_autorizada,
  conta_confirmada,teto_usd_por_episodio
FROM studio_projetos WHERE projeto_id=:projeto_id;

-- CO02: fila completa. Voz e arte são acompanhadas separadamente durante produção.
SELECT slug,titulo,formato,lote,etapa,responsavel,estado_voz,estado_arte,
  roteiro_versao,video_versao,bloqueio,atualizado_em
FROM studio_fila WHERE projeto_id=:projeto_id
  AND etapa NOT IN ('publicado','vetado') ORDER BY criado_em,slug;

-- CO03: candidatas de pauta, com data do último episódio sobre o mesmo item.
SELECT t.slug,t.titulo,t.categoria,t.item,t.angulo,t.veredito_editorial,
  (SELECT MAX(e.criado_em) FROM studio_episodios e
   JOIN studio_temas t2 ON t2.projeto_id=e.projeto_id AND t2.slug=e.tema_slug
   WHERE e.projeto_id=t.projeto_id AND t2.item=t.item) AS ultimo_episodio_do_item
FROM studio_temas t WHERE t.projeto_id=:projeto_id AND t.status='aprovado'
ORDER BY t.atualizado_em,t.slug;

-- CO04: criar episódio sem duplicar. :piloto é 0 ou 1. Exige tema aprovado do próprio projeto.
INSERT INTO studio_episodios
  (projeto_id,slug,titulo,tema_slug,formato,lote,piloto,etapa,responsavel,pasta)
SELECT :projeto_id,:slug,:titulo,:tema_slug,:formato,:lote,:piloto,'roteiro','coordenacao',:pasta
FROM studio_projetos p WHERE p.projeto_id=:projeto_id
  AND ((p.estado='ativo' AND p.piloto_aprovado=1) OR (p.estado='piloto' AND :piloto=1))
  AND EXISTS (SELECT 1 FROM studio_temas t WHERE t.projeto_id=:projeto_id
    AND t.slug=:tema_slug AND t.status='aprovado')
ON CONFLICT (projeto_id,slug) DO NOTHING;

-- CO05: encaminhar roteiro escrito para revisão, na versão esperada.
UPDATE studio_episodios SET etapa='revisao_roteiro',responsavel='revisao',atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa='roteiro' AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1);

-- CO06: ajuste exato prescrito pela Revisão, aplicado uma vez pela Coordenação.
-- A descrição identifica a troca autorizada. Alegação ou decisão nova usa CO07 e nova revisão.
UPDATE studio_episodios SET roteiro_versao=roteiro_versao+1,ajuste_exato_aplicado=1,
  ajuste_descricao=:ajuste_descricao,etapa='producao',responsavel='producao',atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa='ajuste_roteiro' AND roteiro_veredito='APROVADO COM AJUSTE'
  AND roteiro_revisado_versao=roteiro_versao AND ajuste_exato_aplicado=0
  AND length(trim(:ajuste_descricao))>0
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1);

-- CO07: abrir reescrita material. Invalida derivados; não apaga os arquivos históricos.
UPDATE studio_episodios SET roteiro_versao=roteiro_versao+1,etapa='roteiro',responsavel='coordenacao',
  roteiro_veredito=NULL,roteiro_revisado_versao=NULL,ajuste_exato_aplicado=0,ajuste_descricao=NULL,
  estado_voz='pendente',voz_roteiro_versao=NULL,estado_arte='pendente',arte_roteiro_versao=NULL,
  final_veredito=NULL,final_revisado_versao=NULL,bloqueio=NULL,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND roteiro_versao=:roteiro_versao
  AND etapa NOT IN ('publicado','vetado')
  AND id IN (SELECT id FROM studio_fila WHERE pode_produzir=1);

-- CO08: bloqueios e episódios sem atualização. Investigar o motivo antes de cobrar alguém.
SELECT slug,etapa,responsavel,estado_voz,estado_arte,bloqueio,atualizado_em
FROM studio_fila WHERE projeto_id=:projeto_id
  AND etapa NOT IN ('pronto','publicado','vetado','pausado')
  AND (bloqueio IS NOT NULL OR julianday('now')-julianday(atualizado_em)>:horas_atraso/24.0)
ORDER BY atualizado_em;

-- CO09: custos e limites. NULL significa ausência de valor registrado, não custo zero.
SELECT slug,valor_registrado_usd,valor_medido_usd,registros_custo,
  custos_nao_medidos,custos_sem_valor_usd,teto_usd_por_episodio
FROM studio_fila WHERE projeto_id=:projeto_id ORDER BY criado_em;

-- CO10: entrega interna depois de copiar a versão aprovada para videos-prontos/.
-- Atualizar somente após conferir a cópia. Esta query não copia o arquivo nem publica.
UPDATE studio_episodios SET etapa='pronto',responsavel='coordenacao',notas=:nota_entrega,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND video_versao=:video_versao
  AND etapa='aprovado'
  AND id IN (SELECT id FROM studio_fila WHERE final_liberado=1 AND roteiro_liberado=1 AND pode_produzir=1);

-- CO11: resumo por etapa.
SELECT etapa,COUNT(*) AS quantidade FROM studio_episodios
WHERE projeto_id=:projeto_id GROUP BY etapa ORDER BY etapa;

-- CO12: após criar o episódio, marcar o tema usado. A criação idempotente já deve estar confirmada.
UPDATE studio_temas SET status='usado',atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:tema_slug AND status='aprovado'
  AND EXISTS (SELECT 1 FROM studio_episodios e WHERE e.projeto_id=:projeto_id
    AND e.slug=:slug AND e.tema_slug=studio_temas.slug);

-- Custos: chave única por operação ou pedido. Pode ser o ID retornado pelo provedor.
-- medido=1: valor USD conhecido. medido=0: estimativa ou valor ainda não convertido.
-- Sem valor, custo_usd=NULL; não inventar zero. quantidade pode registrar créditos reais.
INSERT INTO studio_custos
  (projeto_id,episodio_slug,chave,agente,etapa,servico,modelo,unidade,quantidade,custo_usd,medido,nota)
VALUES (:projeto_id,:slug,:chave,:agente,:etapa,:servico,:modelo,:unidade,:quantidade,:custo_usd,:medido,:nota)
ON CONFLICT (projeto_id,chave) DO NOTHING;

-- Atualizar o mesmo registro quando a medição real chegar; não duplicar o custo estimado.
UPDATE studio_custos SET custo_usd=:custo_usd,medido=1,nota=:nota
WHERE projeto_id=:projeto_id AND chave=:chave AND episodio_slug=:slug
  AND :custo_usd IS NOT NULL AND :custo_usd>=0;

-- Antes de gasto novo: proposta deve incluir :proxima_estimativa_usd.
-- A verificação considera valores registrados (medidos ou estimados); reservas concorrentes
-- exigem serialização pelo coordenador ou mecanismo de reservas do provedor.
SELECT slug,valor_registrado_usd,valor_medido_usd,custos_nao_medidos,custos_sem_valor_usd,
  teto_usd_por_episodio,:proxima_estimativa_usd AS proxima_estimativa_usd,
  CASE WHEN pode_produzir=0 THEN 'PROJETO_INATIVO'
    WHEN custos_sem_valor_usd>0 THEN 'RESOLVER_CUSTO_SEM_VALOR'
    WHEN teto_usd_por_episodio IS NULL THEN 'DEFINIR_TETO'
    WHEN :proxima_estimativa_usd IS NULL OR :proxima_estimativa_usd<0 THEN 'ESTIMAR_PROXIMA_OPERACAO'
    WHEN COALESCE(valor_registrado_usd,0)+:proxima_estimativa_usd>teto_usd_por_episodio THEN 'PEDIR_DECISAO'
    ELSE 'DENTRO_DO_TETO_REGISTRADO' END AS situacao
FROM studio_fila WHERE projeto_id=:projeto_id AND slug=:slug;

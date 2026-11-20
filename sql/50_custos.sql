-- Registro em BRL, chave única por operação. NULL = desconhecido, nunca zero inventado.
-- Registrar custo não autoriza gasto. Gestor obtém autorização específica antes de cada despesa.
INSERT INTO tatu_custos (projeto_id,tarefa_id,chave,agente,servico,valor,medido,autorizacao_ref)
VALUES (:projeto_id,:tarefa_id,:chave,:agente,:servico,:valor,:medido,:autorizacao_ref)
ON CONFLICT (projeto_id,chave) DO NOTHING;

-- Substituir estimativa pelo valor realmente medido, sem duplicar a operação.
UPDATE tatu_custos SET valor=:valor,medido=1
WHERE projeto_id=:projeto_id AND chave=:chave AND :valor IS NOT NULL AND :valor>=0;

SELECT SUM(valor) AS valor_registrado_brl,
  SUM(CASE WHEN valor IS NULL THEN 1 ELSE 0 END) AS custos_desconhecidos
FROM tatu_custos WHERE projeto_id=:projeto_id;

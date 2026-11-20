-- Agente 04: calendário, objetivos e métricas observadas. Apenas arquivos realmente gravados.
SELECT * FROM tatu_fila WHERE projeto_id=:projeto_id AND agente='04'
  AND estado_projeto='textual' AND estado IN ('planejado','em_execucao','em_ajustes')
ORDER BY atualizado_em;

-- Registrar calendário, objetivos e métricas observadas e encaminhar à Revisão.
-- Verifique existência, conteúdo e caminho do arquivo antes de executar. SQL não cria arquivos.
INSERT INTO tatu_entregas (projeto_id,tarefa_id,versao,arquivo,resumo)
SELECT projeto_id,tarefa_id,versao,:arquivo,:resumo FROM tatu_fila
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND agente='04' AND estado_projeto='textual' AND estado IN ('planejado','em_execucao')
  AND :arquivo LIKE pasta || '/%' AND instr(:arquivo,'..')=0
ON CONFLICT (projeto_id,tarefa_id,versao) DO NOTHING;

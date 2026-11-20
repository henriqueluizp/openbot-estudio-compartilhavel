-- Revisão independente: examinar arquivos, fontes, briefing e regras Tatu da versão atual.
SELECT * FROM tatu_fila WHERE projeto_id=:projeto_id AND estado_projeto='textual'
  AND estado='em_revisao' ORDER BY atualizado_em;

-- Aprovação textual não aprova mídia ausente. Correções exigem nova versão pelo Gestor.
-- O parecer identifica problemas, gravidade, responsável e evidências.
INSERT INTO tatu_revisoes (projeto_id,tarefa_id,versao,veredito,parecer)
SELECT projeto_id,tarefa_id,versao,:veredito,:parecer FROM tatu_fila
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND estado_projeto='textual' AND estado='em_revisao' AND arquivo IS NOT NULL
ON CONFLICT (projeto_id,tarefa_id,versao) DO NOTHING;

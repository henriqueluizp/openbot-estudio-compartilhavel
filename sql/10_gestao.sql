-- Gestor: consolidar o estado real, dependências e aprovações nos arquivos de gestão.
SELECT * FROM tatu_fila WHERE projeto_id=:projeto_id ORDER BY atualizado_em,tarefa_id;

-- Criar tarefa textual idempotente. Dependências/prazos ficam na ficha em estudio/02-gestao/tarefas/.
INSERT INTO tatu_tarefas (projeto_id,tarefa_id,pedido,objetivo,agente,pasta,criterio)
SELECT :projeto_id,:tarefa_id,:pedido,:objetivo,:agente,:pasta,:criterio
FROM tatu_projetos WHERE projeto_id=:projeto_id AND estado='textual'
ON CONFLICT (projeto_id,tarefa_id) DO NOTHING;

-- Nova versão invalida a liberação anterior sem apagar entregas, pareceres ou recibos.
UPDATE tatu_tarefas SET versao=versao+1,estado='em_execucao',bloqueio=NULL,
  nota=:motivo,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND estado IN ('em_ajustes','revisado','em_revisao') AND length(trim(:motivo))>0
  AND EXISTS (SELECT 1 FROM tatu_projetos p WHERE p.projeto_id=:projeto_id AND p.estado='textual');

-- Registrar planos e relatórios consolidados e encaminhar à Revisão.
-- Verifique existência, conteúdo e caminho do arquivo antes de executar. SQL não cria arquivos.
INSERT INTO tatu_entregas (projeto_id,tarefa_id,versao,arquivo,resumo)
SELECT projeto_id,tarefa_id,versao,:arquivo,:resumo FROM tatu_fila
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND agente='01' AND estado_projeto='textual' AND estado IN ('planejado','em_execucao')
  AND :arquivo LIKE pasta || '/%' AND instr(:arquivo,'..')=0
ON CONFLICT (projeto_id,tarefa_id,versao) DO NOTHING;

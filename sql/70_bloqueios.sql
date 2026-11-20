-- Qualquer agente relata ao Gestor. Preservar motivo e ação também na ficha da tarefa.
UPDATE tatu_tarefas SET estado='bloqueado',bloqueio=:motivo,nota=:acao,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND estado<>'bloqueado' AND length(trim(:motivo))>0 AND length(trim(:acao))>0;

-- Gestor retoma após evidência da resolução. Nova versão exige nova entrega e revisão.
UPDATE tatu_tarefas SET estado='em_execucao',bloqueio=NULL,nota=:resolucao,
  versao=versao+1,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND estado='bloqueado' AND length(trim(:resolucao))>0
  AND EXISTS (SELECT 1 FROM tatu_projetos p WHERE p.projeto_id=:projeto_id AND p.estado='textual');

SELECT * FROM tatu_fila WHERE projeto_id=:projeto_id AND estado='bloqueado';

-- Fila de registros autorizados. NÃO envia nem agenda. Revalidar autorização antes de qualquer ação externa.
SELECT pub.*,f.arquivo FROM tatu_publicacoes pub JOIN tatu_fila f
  USING (projeto_id,tarefa_id,versao)
WHERE pub.projeto_id=:projeto_id AND pub.estado='autorizado' AND f.estado_projeto='textual'
  AND f.estado='revisado' AND f.veredito='aprovado';

-- Só o Gestor registra autorização já dada pelo proprietário para ESTA versão, conta e ação.
-- A referência aponta ao documento privado de aprovação. Não inferir aprovação do parecer editorial.
INSERT INTO tatu_publicacoes (projeto_id,tarefa_id,versao,conta,autorizacao_ref)
SELECT projeto_id,tarefa_id,versao,:conta,:autorizacao_ref FROM tatu_fila
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao
  AND estado_projeto='textual' AND estado='revisado' AND veredito='aprovado'
ON CONFLICT (projeto_id,tarefa_id,versao,conta) DO NOTHING;

-- Somente após confirmação REAL do serviço externo. Não converter roteiro em Reel publicado.
UPDATE tatu_publicacoes SET estado=:estado,recibo=:recibo,link=:link
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao AND conta=:conta
  AND estado IN ('autorizado','agendado','falhou')
  AND :estado IN ('agendado','publicado','falhou') AND length(trim(:recibo))>0
  AND (:estado<>'publicado' OR length(trim(:link))>0)
  AND EXISTS (SELECT 1 FROM tatu_fila f WHERE f.projeto_id=:projeto_id
    AND f.tarefa_id=:tarefa_id AND f.versao=:versao AND f.estado='revisado'
    AND f.veredito='aprovado' AND f.estado_projeto='textual');

-- Revogar antes de qualquer envio. Cancelamento externo precisa ser confirmado no serviço.
UPDATE tatu_publicacoes SET estado='revogado'
WHERE projeto_id=:projeto_id AND tarefa_id=:tarefa_id AND versao=:versao AND conta=:conta
  AND estado IN ('autorizado','agendado');

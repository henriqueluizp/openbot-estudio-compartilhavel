-- Preparar pacote não envia nada. A versão atual deve ter parecer final válido.
INSERT INTO studio_publicacoes
  (projeto_id,episodio_slug,video_versao,conta,rede,pacote)
SELECT projeto_id,slug,video_versao,:conta,:rede,:pacote FROM studio_fila
WHERE projeto_id=:projeto_id AND slug=:slug AND etapa='pronto'
  AND final_liberado=1 AND roteiro_liberado=1
ON CONFLICT (projeto_id,episodio_slug,video_versao,conta,rede) DO NOTHING;

-- Fila apta a envio ao publicador autorizado; não executa envio.
SELECT pub.id,pub.episodio_slug,pub.video_versao,pub.conta,pub.rede,pub.pacote,f.autorizacao_ref
FROM studio_publicacoes pub JOIN studio_fila f
  ON f.projeto_id=pub.projeto_id AND f.slug=pub.episodio_slug
WHERE pub.projeto_id=:projeto_id AND pub.estado='preparado' AND pub.video_versao=f.video_versao
  AND f.etapa='pronto' AND f.final_liberado=1 AND f.roteiro_liberado=1
  AND f.estado_projeto='ativo' AND f.piloto_aprovado=1
  AND f.publicacao_autorizada=1 AND f.conta_confirmada=1;

-- Após envio real, salvar recibo e autorização. A autorização deve cobrir essa conta e esse episódio.
-- O vínculo de conta e escopo é conferido pelo agente no config e pela ferramenta de publicação.
UPDATE studio_publicacoes SET estado='enviado',recibo_externo=:recibo,
  autorizacao_ref=:autorizacao_ref,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND id=:publicacao_id AND estado='preparado'
  AND length(trim(:recibo))>0
  AND EXISTS (SELECT 1 FROM studio_fila f WHERE f.projeto_id=studio_publicacoes.projeto_id
    AND f.slug=studio_publicacoes.episodio_slug AND f.video_versao=studio_publicacoes.video_versao
    AND f.final_liberado=1 AND f.roteiro_liberado=1 AND f.etapa='pronto'
    AND f.estado_projeto='ativo' AND f.piloto_aprovado=1
    AND f.publicacao_autorizada=1 AND f.conta_confirmada=1 AND f.autorizacao_ref=:autorizacao_ref);

-- Consulta de acompanhamento: agendamento/publicação reais devem vir do publicador.
SELECT episodio_slug,video_versao,conta,rede,estado,recibo_externo,link,publicado_em
FROM studio_publicacoes WHERE projeto_id=:projeto_id ORDER BY atualizado_em;

-- Salvar confirmação recebida do publicador; não chamar preparado de publicado sem recibo.
UPDATE studio_publicacoes SET estado=:estado_real,recibo_externo=:recibo,
  link=:link,publicado_em=:publicado_em,atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND id=:publicacao_id
  AND estado IN ('enviado','agendado','falhou')
  AND :estado_real IN ('agendado','publicado','falhou') AND length(trim(:recibo))>0
  AND (:estado_real<>'publicado' OR (length(trim(:link))>0 AND length(trim(:publicado_em))>0));

-- Episódio publicado: vincular à confirmação da versão atual, depois de registrar cada destino.
UPDATE studio_episodios SET etapa='publicado',atualizado_em=datetime('now')
WHERE projeto_id=:projeto_id AND slug=:slug AND etapa='pronto'
  AND EXISTS (SELECT 1 FROM studio_publicacoes pub WHERE pub.projeto_id=:projeto_id
    AND pub.episodio_slug=:slug AND pub.video_versao=studio_episodios.video_versao
    AND pub.estado='publicado' AND length(trim(pub.recibo_externo))>0);

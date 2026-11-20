-- Instalador: base privada separada, sem acesso ao banco interno do OpenBot.
INSERT INTO tatu_projetos (projeto_id,nome) VALUES (:projeto_id,:nome)
ON CONFLICT (projeto_id) DO NOTHING;

-- Somente depois de testar comunicação e arquivos reais. Não autoriza mídia, gasto ou publicação.
UPDATE tatu_projetos SET estado='textual',evidencia_setup=:evidencia
WHERE projeto_id=:projeto_id AND estado='setup'
  AND :evidencia LIKE 'estudio/02-gestao/decisoes/%';

-- Pausar também rotinas reais no OpenBot, caso existam. SQL não controla o aplicativo.
UPDATE tatu_projetos SET estado='pausado' WHERE projeto_id=:projeto_id;

-- Retomada determinada pelo proprietário, com evidência nova. Mídia continua desativada.
UPDATE tatu_projetos SET estado='textual',evidencia_setup=:evidencia
WHERE projeto_id=:projeto_id AND estado='pausado'
  AND :evidencia LIKE 'estudio/02-gestao/decisoes/%';

SELECT * FROM tatu_projetos WHERE projeto_id=:projeto_id;

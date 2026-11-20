-- Coordenação: registrar uma fonte. Credenciais não entram em referência ou nota.
INSERT INTO studio_fontes
  (projeto_id,chave,tipo,titulo,referencia,autoria,uso_permitido,sustenta,limitacoes,leitura_testada,conferida_em)
VALUES (:projeto_id,:chave,:tipo,:titulo,:referencia,:autoria,:uso_permitido,:sustenta,:limitacoes,:leitura_testada,:conferida_em)
ON CONFLICT (projeto_id,chave) DO UPDATE SET
  tipo=excluded.tipo,titulo=excluded.titulo,referencia=excluded.referencia,
  autoria=excluded.autoria,uso_permitido=excluded.uso_permitido,
  sustenta=excluded.sustenta,limitacoes=excluded.limitacoes,
  leitura_testada=excluded.leitura_testada,conferida_em=excluded.conferida_em;

-- Coordenação e Revisão: fontes disponíveis e limites de uso.
SELECT chave,tipo,titulo,referencia,sustenta,limitacoes,leitura_testada,conferida_em
FROM studio_fontes WHERE projeto_id=:projeto_id ORDER BY tipo,chave;

-- Coordenação: tema pesquisado. fontes_json contém chaves cadastradas; a ficha contém alegações e evidências.
INSERT INTO studio_temas
  (projeto_id,slug,titulo,categoria,item,angulo,veredito_editorial,fontes_json,riscos,ficha,status)
VALUES (:projeto_id,:tema_slug,:titulo,:categoria,:item,:angulo,:veredito_editorial,:fontes_json,:riscos,:ficha,:status)
ON CONFLICT (projeto_id,slug) DO NOTHING;

-- Revisão: vincular cada tema às fontes e encontrar chaves ausentes.
SELECT t.slug,t.titulo,j.value AS chave_fonte,f.tipo,f.referencia,f.sustenta,f.limitacoes
FROM studio_temas t, json_each(t.fontes_json) j
LEFT JOIN studio_fontes f ON f.projeto_id=t.projeto_id AND f.chave=j.value
WHERE t.projeto_id=:projeto_id AND t.slug=:tema_slug;

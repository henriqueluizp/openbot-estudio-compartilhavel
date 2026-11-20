# Modelos de busca de fontes

São modelos de busca, não fontes verificadas. A Coordenação substitui as variáveis, abre os resultados e registra documento, autoria, data, trecho e alcance da evidência (`sql/05_fontes.sql`). Se uma fonte já cadastrada responder à pergunta, comece por ela.

## Catálogo e documentação próprios

> Na fonte [chave], localize [tipo de item ou recurso]. Retorne os campos encontrados, a referência da linha ou do documento, a versão ou data e as condições. Aponte diferenças entre a base e a recomendação proposta. Se não houver registro, diga que o item não foi localizado.

## Especificação técnica

```text
site:[dominio-do-fabricante] "[modelo exato]" manual
site:[dominio-do-fabricante] "[modelo exato]" "[atributo]"
```

> Confira a versão, o mercado e o modelo exatos antes de usar a especificação. Uma alegação comercial do fabricante não comprova, por si só, um efeito de saúde ou segurança.

## Fonte oficial do setor

```text
site:[dominio-oficial] "[assunto]" "[orientação ou norma]"
site:[dominio-oficial] "[título do documento]"
```

> Localize o documento vigente, verifique atualizações e extraia apenas as orientações que sustentam a alegação do roteiro. Registre as condições e a população ou o produto a que se aplicam.

O órgão competente depende da pergunta (saúde, segurança de produto, finanças, consumo etc.). O setup define quais domínios oficiais valem para cada tipo de alegação em `config/projeto.json` → `editorial.fontes_oficiais_por_assunto`. Registre a base de opinião separadamente da evidência oficial.

## Referências de formato

> Pesquise [estilo ou formato] em [rede]. Entregue referências acessíveis, o mecanismo narrativo que funciona, a estrutura de gancho e ritmo e uma proposta original para o nosso tema. Preserve autoria e condições de uso; referências não autorizam copiar texto, personagem, trilha ou identidade.

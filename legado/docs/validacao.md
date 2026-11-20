# Validação da instalação

Roteiro para conferir, no OpenBot de destino, que a estrutura funciona antes do piloto. Use dados fictícios e um `projeto_id` de teste, e apague-o depois.

## Pacote

- [ ] JSONs válidos; referências do manifesto a agentes, modelos e consultas apontam para arquivos existentes.
- [ ] Nenhum caminho absoluto, ID de agente ou padrão de chave de API nos arquivos copiados.

## Controle (ciclo sintético)

- [ ] Esquema criado e reaplicado sem erro (`00_schema.sql` é idempotente).
- [ ] Ciclo completo: tema → roteiro → parecer → voz e arte → render registrado → revisão final → entrega.
- [ ] Roteiro sem aprovação não entra em produção; storyboard final depende dos tempos da voz.
- [ ] Parecer associado à versão; repetir uma entrega não conta nova rodada; ajuste exato aplicado uma única vez.
- [ ] Reescrita material (CO07) invalida derivados; projeto pausado impede início de arte e voz.
- [ ] Custos idempotentes, valor desconhecido preservado como `NULL`, medição posterior no mesmo registro e conferência do teto.
- [ ] Publicação exige versão aprovada, autorização com referência, conta confirmada e recibo real.
- [ ] Dois projetos com slugs iguais permanecem isolados; consultas de fontes retornam apenas o projeto correto.

## No destino

- [ ] Os quatro agentes foram criados pelas ferramentas nativas e registrados em `AGENTES.json`.
- [ ] Conectores, credenciais (por referência ao cofre) e acesso às fontes testados com uma leitura real.
- [ ] Motor audiovisual validado com um MP4 real, conforme `estudio/REQUISITOS.md`.

O ciclo de dados não gera mídia nem publica conteúdo; ele não substitui o piloto audiovisual.

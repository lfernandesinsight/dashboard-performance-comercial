# Dashboard de Performance Comercial

Projeto de portfólio: pipeline de dados e dashboard de performance comercial construído sobre o dataset público [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Status

🚧 Em desenvolvimento — Sprint 4 (Analytics avançado); Sprint 2 (Docker) adiada

## Stack

- PostgreSQL nativo (modelo dimensional — star schema)
- SQL puro para ETL (staging → dimensões → fato)
- PowerBI (camada de visualização, tema customizado dark)

## Estrutura

```
sql/            scripts de criação e carga do banco (star schema)
data/           CSVs do Olist (não versionado — ver instruções abaixo)
dashboard/      arquivo PowerBI (.pbix) e tema customizado (.json)
```

## Como reproduzir

1. Baixe os CSVs do [Olist no Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) e coloque em `data/`.
2. Rode os scripts em `sql/` na ordem numérica (`00` cria a base, `01` o schema, `02` a staging, `\copy` carrega os CSVs, `03`-`05` populam dimensões e fato).
3. Abra o `.pbix` em `dashboard/`, aponte a conexão pro seu Postgres local e aplique o tema `theme_performance_comercial.json`.

## Principais achados

- Concentração geográfica de receita em SP, RJ e MG, refletindo o perfil do e-commerce brasileiro.
- Nota média de avaliação cai de ~4,1 (pedidos no prazo) para ~1,7 (8+ dias de atraso) — atraso na entrega tem impacto direto e mensurável na satisfação do cliente.

## Roadmap

- [x] Sprint 1 — Modelagem dimensional + ETL em SQL (staging → dimensões → fato, validado)
- [ ] Sprint 2 — Containerização (Docker) — **adiada**; Postgres nativo no Windows é suficiente por ora
- [x] Sprint 3 — Dashboard PowerBI (4 páginas: Visão Geral, Vendedor, Produto, Logística — tema dark customizado)
- [ ] Sprint 4 — Analytics avançado
- [ ] Sprint 5 — Publicação no portfólio

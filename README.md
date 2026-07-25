# Dashboard de Performance Comercial

Projeto de portfólio: pipeline de dados e dashboard de performance comercial construído sobre o dataset público [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Status

🚧 Em desenvolvimento — Sprint 2 (Containerização)

## Stack

- PostgreSQL (modelo dimensional — star schema)
- SQL puro para ETL (staging → dimensões → fato)
- PowerBI (camada de visualização)

## Estrutura

```
sql/            scripts de criação e carga do banco (star schema)
data/           CSVs do Olist (não versionado — ver instruções abaixo)
dashboard/      arquivo PowerBI (.pbix)
```

## Como reproduzir

1. Baixe os CSVs do [Olist no Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) e coloque em `data/`.
2. Rode os scripts em `sql/` na ordem numérica.
3. Abra o `.pbix` em `dashboard/` e aponte a conexão pro seu Postgres local.

## Roadmap

- [x] Sprint 1 — Modelagem dimensional + ETL em SQL (staging → dimensões → fato, validado)
- [ ] Sprint 2 — Containerização (Docker)
- [ ] Sprint 3 — Dashboard PowerBI
- [ ] Sprint 4 — Analytics avançado
- [ ] Sprint 5 — Publicação no portfólio

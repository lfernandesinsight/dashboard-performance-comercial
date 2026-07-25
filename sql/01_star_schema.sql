-- =====================================================================
-- Dashboard de Performance Comercial — Modelo Dimensional (Star Schema)
-- Fonte: Olist Brazilian E-Commerce Public Dataset
-- Grão do fato: 1 linha = 1 item de pedido (order_item)
-- =====================================================================

-- ---------------------------------------------------------------------
-- DIM_TEMPO
-- ---------------------------------------------------------------------
CREATE TABLE dim_tempo (
    sk_tempo        SERIAL PRIMARY KEY,
    data            DATE UNIQUE NOT NULL,
    ano             SMALLINT NOT NULL,
    mes             SMALLINT NOT NULL,
    nome_mes        VARCHAR(20) NOT NULL,
    trimestre       SMALLINT NOT NULL,
    dia             SMALLINT NOT NULL,
    dia_semana      SMALLINT NOT NULL,     -- 0=domingo ... 6=sábado
    nome_dia_semana VARCHAR(20) NOT NULL,
    is_fim_de_semana BOOLEAN NOT NULL
);

-- ---------------------------------------------------------------------
-- DIM_CLIENTE
-- ---------------------------------------------------------------------
CREATE TABLE dim_cliente (
    sk_cliente          SERIAL PRIMARY KEY,
    customer_id         VARCHAR(32) UNIQUE NOT NULL,  -- id do pedido específico (Olist)
    customer_unique_id  VARCHAR(32) NOT NULL,          -- id real do cliente (recorrência)
    cidade              VARCHAR(100),
    estado              CHAR(2),
    cep_prefixo         VARCHAR(5)
);

-- ---------------------------------------------------------------------
-- DIM_VENDEDOR
-- ---------------------------------------------------------------------
CREATE TABLE dim_vendedor (
    sk_vendedor     SERIAL PRIMARY KEY,
    seller_id       VARCHAR(32) UNIQUE NOT NULL,
    cidade          VARCHAR(100),
    estado          CHAR(2),
    cep_prefixo     VARCHAR(5)
);

-- ---------------------------------------------------------------------
-- DIM_PRODUTO
-- ---------------------------------------------------------------------
CREATE TABLE dim_produto (
    sk_produto          SERIAL PRIMARY KEY,
    product_id          VARCHAR(32) UNIQUE NOT NULL,
    categoria           VARCHAR(100),       -- traduzida via product_category_name_translation
    peso_g              INTEGER,
    comprimento_cm       INTEGER,
    altura_cm            INTEGER,
    largura_cm           INTEGER
);

-- ---------------------------------------------------------------------
-- DIM_PAGAMENTO
-- ---------------------------------------------------------------------
CREATE TABLE dim_pagamento (
    sk_pagamento    SERIAL PRIMARY KEY,
    tipo_pagamento  VARCHAR(30) NOT NULL,   -- credit_card, boleto, voucher, debit_card
    parcelas_max    SMALLINT                -- maior nº de parcelas observado nesse tipo/pedido
);

-- ---------------------------------------------------------------------
-- DIM_GEOGRAFIA  (opcional — granularidade de cidade/estado já cabe nas
-- dims cliente/vendedor; use esta tabela só se for cruzar lat/long)
-- ---------------------------------------------------------------------
CREATE TABLE dim_geografia (
    sk_geografia    SERIAL PRIMARY KEY,
    cep_prefixo     VARCHAR(5) UNIQUE NOT NULL,
    cidade          VARCHAR(100),
    estado          CHAR(2),
    latitude        NUMERIC(10,6),
    longitude       NUMERIC(10,6)
);

-- ---------------------------------------------------------------------
-- FATO_PEDIDOS  (grão: item de pedido)
-- ---------------------------------------------------------------------
CREATE TABLE fato_pedidos (
    sk_fato                 BIGSERIAL PRIMARY KEY,
    order_id                VARCHAR(32) NOT NULL,
    order_item_id           SMALLINT NOT NULL,

    -- chaves estrangeiras (dimensões)
    sk_tempo_compra         INTEGER REFERENCES dim_tempo(sk_tempo),
    sk_tempo_entrega        INTEGER REFERENCES dim_tempo(sk_tempo),
    sk_cliente              INTEGER REFERENCES dim_cliente(sk_cliente),
    sk_vendedor             INTEGER REFERENCES dim_vendedor(sk_vendedor),
    sk_produto              INTEGER REFERENCES dim_produto(sk_produto),
    sk_pagamento            INTEGER REFERENCES dim_pagamento(sk_pagamento),

    -- métricas
    preco                   NUMERIC(10,2) NOT NULL,
    valor_frete             NUMERIC(10,2) NOT NULL,
    valor_pago              NUMERIC(10,2),

    -- datas brutas (mantidas pra cálculo de prazo, além das FKs de dim_tempo)
    data_compra              TIMESTAMP,
    data_entrega_estimada    DATE,
    data_entrega_real        TIMESTAMP,
    dias_atraso              INTEGER,          -- calculado: real - estimado (negativo = adiantado)

    -- review
    nota_avaliacao           SMALLINT,         -- 1 a 5

    status_pedido            VARCHAR(20)
);

-- Índices de apoio às queries mais comuns do dashboard
CREATE INDEX idx_fato_sk_tempo_compra ON fato_pedidos(sk_tempo_compra);
CREATE INDEX idx_fato_sk_vendedor     ON fato_pedidos(sk_vendedor);
CREATE INDEX idx_fato_sk_produto      ON fato_pedidos(sk_produto);
CREATE INDEX idx_fato_sk_cliente      ON fato_pedidos(sk_cliente);

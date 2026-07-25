-- =====================================================================
-- STAGING — carga bruta dos CSVs do Olist (schema "staging")
-- Estrutura espelha os arquivos originais do dataset, sem transformação
-- =====================================================================

CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE staging.customers (
    customer_id                VARCHAR(32),
    customer_unique_id         VARCHAR(32),
    customer_zip_code_prefix   VARCHAR(5),
    customer_city              VARCHAR(100),
    customer_state             CHAR(2)
);

CREATE TABLE staging.orders (
    order_id                       VARCHAR(32),
    customer_id                    VARCHAR(32),
    order_status                   VARCHAR(20),
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  DATE
);

CREATE TABLE staging.order_items (
    order_id            VARCHAR(32),
    order_item_id       SMALLINT,
    product_id          VARCHAR(32),
    seller_id           VARCHAR(32),
    shipping_limit_date TIMESTAMP,
    price                NUMERIC(10,2),
    freight_value        NUMERIC(10,2)
);

CREATE TABLE staging.order_payments (
    order_id            VARCHAR(32),
    payment_sequential  SMALLINT,
    payment_type        VARCHAR(30),
    payment_installments SMALLINT,
    payment_value        NUMERIC(10,2)
);

CREATE TABLE staging.order_reviews (
    review_id               VARCHAR(32),
    order_id                VARCHAR(32),
    review_score             SMALLINT,
    review_comment_title     TEXT,
    review_comment_message   TEXT,
    review_creation_date     TIMESTAMP,
    review_answer_timestamp  TIMESTAMP
);

CREATE TABLE staging.products (
    product_id                  VARCHAR(32),
    product_category_name       VARCHAR(100),
    product_name_lenght          INTEGER,
    product_description_lenght   INTEGER,
    product_photos_qty           INTEGER,
    product_weight_g             INTEGER,
    product_length_cm            INTEGER,
    product_height_cm            INTEGER,
    product_width_cm             INTEGER
);

CREATE TABLE staging.sellers (
    seller_id                VARCHAR(32),
    seller_zip_code_prefix   VARCHAR(5),
    seller_city              VARCHAR(100),
    seller_state              CHAR(2)
);

CREATE TABLE staging.category_translation (
    product_category_name          VARCHAR(100),
    product_category_name_english  VARCHAR(100)
);

-- =====================================================================
-- Carga via COPY (rodar no psql, ajustando o caminho dos CSVs)
-- =====================================================================
-- \copy staging.customers          FROM 'data/olist_customers_dataset.csv' CSV HEADER;
-- \copy staging.orders             FROM 'data/olist_orders_dataset.csv' CSV HEADER;
-- \copy staging.order_items        FROM 'data/olist_order_items_dataset.csv' CSV HEADER;
-- \copy staging.order_payments     FROM 'data/olist_order_payments_dataset.csv' CSV HEADER;
-- \copy staging.order_reviews      FROM 'data/olist_order_reviews_dataset.csv' CSV HEADER;
-- \copy staging.products           FROM 'data/olist_products_dataset.csv' CSV HEADER;
-- \copy staging.sellers            FROM 'data/olist_sellers_dataset.csv' CSV HEADER;
-- \copy staging.category_translation FROM 'data/product_category_name_translation.csv' CSV HEADER;

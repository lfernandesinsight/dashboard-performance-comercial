-- =====================================================================
-- POPULAÇÃO — DIM_CLIENTE
-- =====================================================================
INSERT INTO dim_cliente (customer_id, customer_unique_id, cidade, estado, cep_prefixo)
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state,
    customer_zip_code_prefix
FROM staging.customers
ON CONFLICT (customer_id) DO NOTHING;

-- =====================================================================
-- POPULAÇÃO — DIM_VENDEDOR
-- =====================================================================
INSERT INTO dim_vendedor (seller_id, cidade, estado, cep_prefixo)
SELECT DISTINCT
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix
FROM staging.sellers
ON CONFLICT (seller_id) DO NOTHING;

-- =====================================================================
-- POPULAÇÃO — DIM_PRODUTO
-- (categoria traduzida para inglês; troque para pt.product_category_name
--  se preferir manter a categoria original em português)
-- =====================================================================
INSERT INTO dim_produto (product_id, categoria, peso_g, comprimento_cm, altura_cm, largura_cm)
SELECT DISTINCT
    p.product_id,
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown'),
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM staging.products p
LEFT JOIN staging.category_translation t
    ON t.product_category_name = p.product_category_name
ON CONFLICT (product_id) DO NOTHING;

-- =====================================================================
-- POPULAÇÃO — DIM_PAGAMENTO (junk dimension)
-- Uma linha por combinação (tipo, nº de parcelas) realmente observada —
-- não um agregado. É essa combinação exata que cada pedido vai referenciar.
-- Renomeando conceitualmente: "parcelas_max" aqui = parcelas do pedido.
-- =====================================================================
INSERT INTO dim_pagamento (tipo_pagamento, parcelas_max)
SELECT DISTINCT
    payment_type,
    payment_installments
FROM staging.order_payments;

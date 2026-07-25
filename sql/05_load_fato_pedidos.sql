-- =====================================================================
-- POPULAÇÃO — FATO_PEDIDOS
-- Grão: 1 linha por item de pedido (order_id + order_item_id)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Passo 1: resolver o pagamento "representativo" de cada pedido.
-- Um pedido pode ter múltiplas linhas de pagamento (ex: voucher + cartão).
-- Critério: a linha de maior valor pago é a que melhor representa o pedido.
-- ---------------------------------------------------------------------
CREATE TEMP TABLE tmp_pagamento_pedido AS
SELECT
    rep.order_id,
    rep.payment_type,
    rep.payment_installments,
    tot.valor_pago_total
FROM (
    SELECT DISTINCT ON (order_id)
        order_id, payment_type, payment_installments
    FROM staging.order_payments
    ORDER BY order_id, payment_value DESC
) rep
JOIN (
    SELECT order_id, SUM(payment_value) AS valor_pago_total
    FROM staging.order_payments
    GROUP BY order_id
) tot ON tot.order_id = rep.order_id;

-- ---------------------------------------------------------------------
-- Passo 2: resolver a nota de avaliação de cada pedido.
-- Um pedido pode ter mais de uma review (raro) — pega a mais recente.
-- ---------------------------------------------------------------------
CREATE TEMP TABLE tmp_review_pedido AS
SELECT DISTINCT ON (order_id)
    order_id,
    review_score
FROM staging.order_reviews
ORDER BY order_id, review_creation_date DESC;

-- ---------------------------------------------------------------------
-- Passo 3: carga do fato
-- ---------------------------------------------------------------------
INSERT INTO fato_pedidos (
    order_id, order_item_id,
    sk_tempo_compra, sk_tempo_entrega,
    sk_cliente, sk_vendedor, sk_produto, sk_pagamento,
    preco, valor_frete, valor_pago,
    data_compra, data_entrega_estimada, data_entrega_real, dias_atraso,
    nota_avaliacao, status_pedido
)
SELECT
    oi.order_id,
    oi.order_item_id,

    dt_compra.sk_tempo   AS sk_tempo_compra,
    dt_entrega.sk_tempo  AS sk_tempo_entrega,

    dc.sk_cliente,
    dv.sk_vendedor,
    dp.sk_produto,
    dpg.sk_pagamento,

    oi.price               AS preco,
    oi.freight_value       AS valor_frete,
    pp.valor_pago_total    AS valor_pago,  -- total pago no pedido; repetido nos itens do mesmo pedido (aproximação)

    o.order_purchase_timestamp    AS data_compra,
    o.order_estimated_delivery_date AS data_entrega_estimada,
    o.order_delivered_customer_date AS data_entrega_real,
    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
        THEN (o.order_delivered_customer_date::date - o.order_estimated_delivery_date)
        ELSE NULL
    END AS dias_atraso,

    rv.review_score        AS nota_avaliacao,
    o.order_status          AS status_pedido

FROM staging.order_items oi
JOIN staging.orders o
    ON o.order_id = oi.order_id
LEFT JOIN dim_cliente dc
    ON dc.customer_id = o.customer_id
LEFT JOIN dim_vendedor dv
    ON dv.seller_id = oi.seller_id
LEFT JOIN dim_produto dp
    ON dp.product_id = oi.product_id
LEFT JOIN tmp_pagamento_pedido pp
    ON pp.order_id = o.order_id
LEFT JOIN dim_pagamento dpg
    ON dpg.tipo_pagamento = pp.payment_type
   AND dpg.parcelas_max = pp.payment_installments
LEFT JOIN tmp_review_pedido rv
    ON rv.order_id = o.order_id
LEFT JOIN dim_tempo dt_compra
    ON dt_compra.data = o.order_purchase_timestamp::date
LEFT JOIN dim_tempo dt_entrega
    ON dt_entrega.data = o.order_delivered_customer_date::date;

DROP TABLE tmp_pagamento_pedido;
DROP TABLE tmp_review_pedido;

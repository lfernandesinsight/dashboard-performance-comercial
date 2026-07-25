-- =====================================================================
-- POPULAÇÃO — DIM_TEMPO
-- Gera o calendário cobrindo todo o período do dataset (2016-2018 + margem)
-- =====================================================================

INSERT INTO dim_tempo (data, ano, mes, nome_mes, trimestre, dia, dia_semana, nome_dia_semana, is_fim_de_semana)
SELECT
    d::date                                            AS data,
    EXTRACT(YEAR FROM d)::SMALLINT                      AS ano,
    EXTRACT(MONTH FROM d)::SMALLINT                     AS mes,
    TO_CHAR(d, 'TMMonth')                               AS nome_mes,
    EXTRACT(QUARTER FROM d)::SMALLINT                   AS trimestre,
    EXTRACT(DAY FROM d)::SMALLINT                       AS dia,
    EXTRACT(DOW FROM d)::SMALLINT                       AS dia_semana,
    TO_CHAR(d, 'TMDay')                                 AS nome_dia_semana,
    EXTRACT(DOW FROM d) IN (0, 6)                       AS is_fim_de_semana
FROM generate_series('2016-01-01'::date, '2019-12-31'::date, interval '1 day') AS d
ON CONFLICT (data) DO NOTHING;

-----------------------------------------------------------------------------------------
-- PERGUNTA: Qual o total de receita gerada e a quantidade de produtos vendidos por mês?
-----------------------------------------------------------------------------------------

WITH resumo_mensal AS (
    SELECT
        -- Componente Temporal: Normalizando a data da venda para o primeiro dia do mês correspondente
        DATE_TRUNC('month', order_date) AS mes,
        sales AS valor_venda,
        product_id AS produto
    FROM 
        vendas_2018
)

SELECT
    -- Formatação de Saída: Convertendo o campo de data para string legível em relatórios (Ex: 2018-01)
    TO_CHAR(mes, 'YYYY-MM') AS periodo, 
    
    -- Métrica de Receita: Consolidação do faturamento bruto gerado no intervalo mensal
    CAST(SUM(valor_venda) AS DECIMAL(10,2)) AS receita_total, 
    
    -- Métrica de Volume: Contagem total de itens transacionados no período
    COUNT(produto) AS total_produtos_vendidos

FROM 
    resumo_mensal
GROUP BY 
    mes
    
-- Ordenação Cronológica: Garante a linha do tempo correta para análises de sazonalidade e tendência
ORDER BY 
    mes ASC;

-----------------------------------------------------------------------------------------
-- PERGUNTA: Quem são os nossos 5 melhores vendedores em termos de faturamento acumulado 
-- e qual é o valor exato da comissão que devemos pagar para cada um deles no período?
-----------------------------------------------------------------------------------------

WITH vendas_comissionadas AS (
    SELECT
        v.id_vendedor,
        v.sales,
        
        -- Regra de Negócio: O percentual de comissão varia de acordo com a margem da categoria do produto
        CASE
            WHEN v.category = 'Furniture'       THEN v.sales * 0.03 -- 3% para Móveis
            WHEN v.category = 'Office Supplies' THEN v.sales * 0.05 -- 5% para Suprimentos de Escritório
            WHEN v.category = 'Technology'      THEN v.sales * 0.02 -- 2% para Tecnologia
            ELSE 0
        END AS comissao_da_venda
    FROM 
        vendas_2018 v
)

SELECT
    vc.id_vendedor,
    vd.nome_vendedor,
    
    -- Padronização monetária (Duas casas decimais) para relatórios financeiros e de auditoria
    CAST(SUM(vc.sales) AS DECIMAL(10,2)) AS faturamento_acumulado,
    CAST(SUM(vc.comissao_da_venda) AS DECIMAL(10,2)) AS comissao_total

FROM 
    vendas_comissionadas vc
INNER JOIN 
    vendedores vd ON vc.id_vendedor = vd.id_vendedor

GROUP BY
    vc.id_vendedor,
    vd.nome_vendedor

-- Filtro de Negócio: Isolando apenas o Top 5 de maior receita para o ranking comercial
ORDER BY 
    faturamento_acumulado DESC
LIMIT 5;

-----------------------------------------------------------------------------------------
-- PERGUNTA: O vendedor que mais faturou foi também o que fechou a maior quantidade de 
-- pedidos, ou ele ganhou o topo por causa de algumas poucas vendas de valor muito alto?
-----------------------------------------------------------------------------------------

WITH ranking_vendedores AS (
    SELECT
        v.id_vendedor,
        vd.nome_vendedor,
        COUNT(v.sales) AS quantidade_pedidos,
        CAST(SUM(v.sales) AS DECIMAL(10,2)) AS faturamento_acumulado,
        
        -- Métrica de Posição: Cria um ranking baseado no volume transacional (1º lugar = mais pedidos)
        RANK() OVER (ORDER BY COUNT(v.sales) DESC) AS rank_quantidade,
        
        -- Métrica de Posição: Cria um ranking baseado na receita gerada (1º lugar = mais faturamento)
        RANK() OVER (ORDER BY SUM(v.sales) DESC) AS rank_faturamento
    FROM 
        vendas_2018 v
    INNER JOIN 
        vendedores vd ON v.id_vendedor = vd.id_vendedor
    GROUP BY
        v.id_vendedor,
        vd.nome_vendedor
)

SELECT
    id_vendedor,
    nome_vendedor,
    quantidade_pedidos,
    faturamento_acumulado,
    
    -- Indicador Comercial: Nova métrica de Ticket Médio que responde à dúvida exata do gestor
    CAST((faturamento_acumulado / quantidade_pedidos) AS DECIMAL(10,2)) AS ticket_medio_por_pedido,
    rank_quantidade,
    rank_faturamento
FROM 
    ranking_vendedores
    
-- Regra de Filtro: Isolando o Top 5 de ambas as visões para analisar discrepâncias de comportamento
WHERE 
    rank_quantidade <= 5 OR rank_faturamento <= 5
ORDER BY 
    rank_faturamento ASC;

-----------------------------------------------------------------------------------------
-- PERGUNTA: Quais vendedores estão trazendo mais receita vendendo 'Technology' e 
-- 'Furniture' (produtos mais caros)? Existe algum vendedor que está vendendo muito, 
-- mas apenas itens de baixo valor de 'Office Supplies'?
-----------------------------------------------------------------------------------------

WITH faturamento_por_categoria AS (
    SELECT
        v.id_vendedor,
        vd.nome_vendedor,
        
        -- Visão Estratégica: Soma o faturamento apenas se o produto for de alto valor unitário
        SUM(CASE WHEN v.category IN ('Technology', 'Furniture') THEN v.sales ELSE 0 END) AS receita_itens_caros,
        
        -- Visão de Volume: Soma o faturamento apenas se o produto for de baixo valor unitário
        SUM(CASE WHEN v.category = 'Office Supplies' THEN v.sales ELSE 0 END) AS receita_itens_baratos,
        
        -- Métrica de Esforço: Conta o total de pedidos para identificar alta operação com baixa receita
        COUNT(v.order_id) AS total_pedidos_geral
    FROM 
        vendas_2018 v
    INNER JOIN 
        vendedores vd ON v.id_vendedor = vd.id_vendedor
    GROUP BY
        v.id_vendedor,
        vd.nome_vendedor
)

SELECT
    id_vendedor,
    nome_vendedor,
    total_pedidos_geral,
    
    -- Padronização monetária para relatórios gerenciais e análise de mix de produtos
    CAST(receita_itens_caros AS DECIMAL(10,2)) AS faturamento_premium,
    CAST(receita_itens_baratos AS DECIMAL(10,2)) AS faturamento_volume
FROM 
    faturamento_por_categoria

-- Ordenação Focada: Direcionando o topo do relatório para quem lidera em produtos premium
ORDER BY 
    faturamento_premium DESC;

-----------------------------------------------------------------------------------------
-- PERGUNTA: Os vendedores mais antigos (contratados antes de 2014) vendem mais do que 
-- os contratados mais recentemente (entre 2015 e 2017)? Quero entender se o nosso 
-- tempo de rampa e treinamento está gerando resultados.
-----------------------------------------------------------------------------------------

WITH segmentacao_vendedores AS (
    SELECT
        v.id_vendedor,
        vd.nome_vendedor,
        vd.data_contratacao,
        
        -- Regra Analítica: Agrupamento por safras contratuais para estudo de maturação interna
        CASE
            WHEN vd.data_contratacao < '2014-01-01' THEN 'Veteranos (Antes de 2014)'
            WHEN vd.data_contratacao >= '2015-01-01' AND vd.data_contratacao <= '2017-12-31' THEN 'Novatos (2015 - 2017)'
            ELSE 'Outros'
        END AS grupo_vendedor,
        
        SUM(v.sales) AS faturamento_total_vendedor
    FROM 
        vendas_2018 v
    INNER JOIN 
        vendedores vd ON v.id_vendedor = vd.id_vendedor
    GROUP BY
        v.id_vendedor,
        vd.nome_vendedor,
        vd.data_contratacao
)

SELECT
    grupo_vendedor,
    COUNT(id_vendedor) AS total_vendedores_no_grupo,
    
    -- Agrupamento Macroeconômico: Volume total gerado por safra comercial
    CAST(SUM(faturamento_total_vendedor) AS DECIMAL(10,2)) AS faturamento_total_grupo,
    
    -- Indicador Chave (KPI): Produtividade per capita (Métrica justa de performance por grupo)
    CAST(AVG(faturamento_total_vendedor) AS DECIMAL(10,2)) AS faturamento_medio_por_vendedor
FROM 
    segmentacao_vendedores

-- Limpeza de Escopo: Remove do relatório registros fora das janelas temporais solicitadas
WHERE 
    grupo_vendedor != 'Outros'
GROUP BY 
    grupo_vendedor

-- Ordenação por Eficiência: Evidencia qual grupo possui o melhor desempenho individual médio
ORDER BY 
    faturamento_medio_por_vendedor DESC;
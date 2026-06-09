-----------------------------------------------------------------------------------------
-- SCRIPT DE CONFIGURAÇÃO: Criação das tabelas e definição do Schema
-----------------------------------------------------------------------------------------

-- 1. Criação da tabela de Vendedores
CREATE TABLE vendedores (
    id_vendedor INT PRIMARY KEY,
    nome_vendedor VARCHAR(100),
    data_contratacao DATE
);

-- 2. Criação da tabela de Vendas
CREATE TABLE vendas_2018 (
    id_venda SERIAL PRIMARY KEY,
    order_id VARCHAR(50),
    order_date DATE,
    id_vendedor INT,
    sales DECIMAL(10,2),
    category VARCHAR(50),
    product_id VARCHAR(50),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
);

-- NOTA DE IMPORTAÇÃO:
-- Para importar os dados do CSV do Kaggle para este banco local, utilizei o comando COPY (PostgreSQL) 
-- ou a ferramenta de Import Wizard do pgAdmin.
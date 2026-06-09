# 📊 Análise Descritiva: Performance Comercial e Otimização de Comissões
### Auditoria Financeira e Análise de Performance Comercial com SQL Avançado | PostgreSQL

> Projeto de análise descritiva que mapeia o desempenho de equipes de vendas, perfila vendedores por senioridade e automatiza o cálculo preciso de comissões por categoria de produto — eliminando ambiguidade nos pagamentos e gerando visibilidade estratégica para as áreas Financeira e Comercial.

---

## 📌 Sobre o Projeto

- Foco em Negócios: Aplicação de SQL avançado no PostgreSQL para responder a perguntas críticas sobre performance de vendas, cálculo de comissões e eficácia de treinamentos.

- Modelagem e Cruzamento de Dados: Combinação de um dataset público do Kaggle com uma tabela autoral de vendedores via INNER JOIN, simulando um cenário real de remuneração variável.

- Autonomia em SQL: Toda a lógica analítica foi desenvolvida exclusivamente em SQL, sem dependência de ferramentas de BI ou outras linguagens, demonstrando domínio técnico na manipulação de dados.

---

## 🔴 O Problema de Negócio

Equipes comerciais de médio e grande porte enfrentam dois desafios recorrentes que impactam diretamente resultados financeiros e clima organizacional:

**1. Falta de visibilidade sobre performance individual e coletiva**

Sem dados organizados, a gestão não sabe se quem vende mais ganha pelo volume de pedidos ou por poucas vendas de valor alto, além de não conseguir identificar quais produtos estão vendendo menos ou comparar o desempenho de funcionários novos e antigos.

**2. Cálculo manual e impreciso de comissões**

A empresa opera com regras de comissionamento diferenciadas por categoria de produto:

| Categoria | Taxa de Comissão |
|---|---|
| 🪑 Furniture | 3% sobre o valor do produto |
| 🖊️ Office Supplies | 5% sobre o valor do produto |
| 💻 Technology | 2% sobre o valor do produto |

Aplicar essas regras manualmente — especialmente em grandes volumes — abre margem para erros, retrabalho e questionamentos. A ausência de um processo auditável compromete a confiança da equipe e a eficiência do setor financeiro.

---

## 🛠️ Habilidades Técnicas Aplicadas

Competências SQL diretamente demonstradas neste projeto:

- **CTEs** — `WITH` para organização e reutilização de subqueries complexas
- **Joins** — `INNER JOIN` para cruzamento entre fontes de dados distintas
- **Lógica condicional** — `CASE WHEN` para aplicação das regras de comissão por categoria
- **Window Functions** — `RANK() OVER (PARTITION BY / ORDER BY)` para ranking de vendedores
- **Agregações** — `SUM()`, `COUNT()`, `AVG()` com `GROUP BY`
- **Manipulação de datas** — `DATE_TRUNC()`, `TO_CHAR()`, `EXTRACT(YEAR FROM ...)`
- **Conversão de tipos** — `CAST()`
- **Filtros e ordenação** — `WHERE`, `ORDER BY`, `LIMIT`, `IN`

---

## 📂 Fonte dos Dados

Os dados utilizados neste projeto foram extraídos do dataset público **Superstore Sales Dataset**, disponível na plataforma Kaggle: [acesse aqui](https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting).

A base original contém o histórico de transações comerciais, permitindo a análise de faturamento, performance por categoria de produto e a modelagem do sistema de comissões. A ela foi adicionada uma **tabela autoral de vendedores**, criada do zero com dados 100% fictícios para viabilizar as análises de senioridade e remuneração variável.

---

## 🗂️ Modelagem & Dicionário de Dados

O projeto utiliza duas tabelas conectadas pela chave `id_vendedor`:

```
[Kaggle Dataset]          [Tabela Autoral]
tabela_vendas      ◄────► tabela_vendedores
     |                         |
  id_vendedor (FK) ──── id_vendedor (PK)
```

**`tabela_vendas`** *(fonte: Kaggle)*

| Coluna | Tipo | Descrição |
|---|---|---|
| `id_pedido` | VARCHAR | Identificador único do pedido |
| `data_pedido` | DATE | Data de realização da venda |
| `id_vendedor` | VARCHAR | Chave de junção com `tabela_vendedores` |
| `categoria` | VARCHAR | Categoria do produto (Furniture, Office Supplies, Technology) |
| `valor_produto` | NUMERIC | Valor bruto do produto vendido |

**`tabela_vendedores`** *(fonte: autoral)*

| Coluna | Tipo | Descrição |
|---|---|---|
| `id_vendedor` | VARCHAR | Chave primária do vendedor |
| `nome_vendedor` | VARCHAR | Nome fictício do colaborador |
| `data_contratacao` | DATE | Data de entrada na empresa |

---

## ❓ Perguntas de Negócio & Insights

As queries SQL direcionadas para responder às perguntas de negócio podem ser encontradas em [`perguntas_comerciais.sql`](https://github.com/isa-amorim/analise-descritiva-performance-vendas-comissoes/blob/main/perguntas_comerciais.sql).

---

## 🎯 Resultados & Impacto

A automação e análise das queries entregam valor concreto para três frentes estratégicas:

### 1. Área Financeira: Auditabilidade e Precisão

A aplicação da lógica de comissionamento variável foi automatizada com base nas regras do negócio:
Móveis: 3%, Suprimentos: 5%, Tecnologia: 2%

O cálculo deixa de ser um processo manual passível de erros operacionais, tornando-se uma rotina SQL rastreável, rápida e totalmente auditável para os fechamentos mensais.

### 2. Área Comercial: Visão de Performance (Ticket Médio vs. Volume)

Ao cruzar o volume de pedidos com o faturamento acumulado e calcular o **Ticket Médio por Vendedor**, a gestão ganha clareza sobre o perfil da força de vendas. Isso permite identificar quem traz receita por recorrência de contratos versus quem atinge a meta com poucas vendas de alto valor (produtos *Premium*).

### 3. Gestão de Pessoas: Avaliação do Tempo de Rampa

A segmentação entre vendedores "Veteranos" (admitidos antes de 2014) e "Novatos" (admitidos entre 2015 e 2017) revelou dados objetivos sobre o programa de treinamento, ajudando a liderança a entender se o tempo de maturação interna está gerando os resultados esperados em faturamento médio.

---

## 🚀 Como Executar

**Pré-requisitos:** PostgreSQL instalado localmente ou acesso a um ambiente cloud (ex: Supabase, Railway).

```bash
# 1. Clone o repositório
git clone https://github.com/isa-amorim/analise-descritiva-performance-vendas-comissoes.git

# 2. Acesse a pasta do projeto
cd analise-descritiva-performance-vendas-comissoes

# 3. Importe as tabelas no seu banco PostgreSQL
psql -U postgres -d ControleVendas -f schema/vendas_2018.sql
psql -U postgres -d ControleVendas -f schema/vendedores.sql

# 4. Execute as queries em perguntas_comerciais.sql
```

---

## 👤 Autora

Feito com 🎯 por **Isabelle Amorim**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/isabelleamorimb)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/isa-amorim)

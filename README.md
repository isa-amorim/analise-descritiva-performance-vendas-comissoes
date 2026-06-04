# analise-descritiva-performance-vendas-comissoes
Projeto de análise descritiva e auditoria financeira utilizando SQL avançado para avaliar a performance de equipes comerciais, mapear perfis de vendedores e otimizar o cálculo de comissões bancárias.

# 📊 Sales Performance & Commission Audit
### Auditoria Financeira e Análise de Performance Comercial com SQL Avançado | PostgreSQL

> Projeto de análise descritiva que mapeia o desempenho de equipes de vendas, perfila vendedores por senioridade e automatiza o cálculo preciso de comissões bancárias por categoria de produto — eliminando ambiguidade nos pagamentos e gerando visibilidade estratégica para as áreas Financeira e Comercial.

---

## 📌 Sobre o Projeto

Este projeto aplica **SQL avançado no PostgreSQL** para responder perguntas críticas de negócio sobre uma operação comercial: quem são os melhores vendedores, quanto cada um deve receber de comissão e se o programa de treinamento da empresa está gerando resultados mensuráveis.

A base analítica combina um **dataset público do Kaggle** com uma **tabela autoral de vendedores**, criada do zero para simular regras reais de remuneração variável. O cruzamento entre as fontes via `INNER JOIN` permite uma visão integrada de receita, volume e perfil de cada colaborador.

O projeto não depende de ferramentas de BI ou linguagens adicionais: **toda a lógica analítica foi construída exclusivamente em SQL**, demonstrando domínio profundo da linguagem como ferramenta de análise de dados.

---

## 🔴 O Problema de Negócio

Equipes comerciais de médio e grande porte enfrentam dois desafios recorrentes que impactam diretamente resultados financeiros e clima organizacional:

**1. Falta de visibilidade sobre performance individual e coletiva**

Sem uma visão consolidada por vendedor, gestor e diretoria operam no escuro: não sabem se o top performer chegou ao topo por volume consistente ou por poucas vendas de alto valor, não conseguem comparar coortes de senioridade e não identificam quais segmentos de produto estão sendo subexplorados.

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

## 🗂️ Estrutura de Dados & Modelagem

### Fontes de Dados

O projeto utiliza duas tabelas conectadas pela chave `id_vendedor`:

```
[Kaggle Dataset]          [Tabela Autoral]
tabela_vendas      ◄────► tabela_vendedores
     |                         |
  id_vendedor (FK) ──── id_vendedor (PK)
```

A tabela `tabela_vendedores` foi **criada do zero** com dados 100% fictícios para simular um cenário real de RH/Comercial, viabilizando análises de senioridade e comissionamento que não existiriam na fonte original.

---

### Dicionário de Dados

**`tabela_vendas`** *(fonte: Kaggle)*

| Coluna | Tipo | Descrição |
|---|---|---|
| `id_pedido` | VARCHAR | Identificador único do pedido |
| `data_pedido` | DATE | Data de realização da venda |
| `id_vendedor` | VARCHAR | Chave de junção com `tabela_vendedores` |
| `categoria` | VARCHAR | Categoria do produto (Furniture, Office Supplies, Technology) |
| `valor_produto` | NUMERIC | Valor bruto do produto vendido |
| `quantidade` | INTEGER | Quantidade de itens no pedido |

**`tabela_vendedores`** *(fonte: autoral)*

| Coluna | Tipo | Descrição |
|---|---|---|
| `id_vendedor` | VARCHAR | Chave primária do vendedor |
| `nome_vendedor` | VARCHAR | Nome fictício do colaborador |
| `data_contratacao` | DATE | Data de entrada na empresa |

---

## ❓ Perguntas de Negócio, Queries & Insights

---

### Pergunta 1 — Qual o total de receita gerada e a quantidade de produtos vendidos por mês?

**Objetivo:** Construir a série histórica mensal de receita e volume para identificar sazonalidade e tendências da operação comercial.

**Query:**

```sql
-- Cole aqui a sua consulta SQL
```

**Resultado:**

```
-- Cole aqui o output da consulta
```

---

### Pergunta 2 — Quem são os 5 melhores vendedores por faturamento e qual é o valor exato da comissão a pagar?

**Objetivo:** Rankear os top performers e calcular automaticamente a comissão de cada um, aplicando as regras de percentual por categoria (`CASE WHEN`), eliminando cálculo manual e garantindo auditabilidade.

**Query:**

```sql
-- Cole aqui a sua consulta SQL
```

**Resultado:**

```
-- Cole aqui o output da consulta
```

---

### Pergunta 3 — O vendedor que mais faturou foi também o que fechou mais pedidos?

**Objetivo:** Diferenciar dois perfis distintos de alta performance: o vendedor de **volume** (muitos pedidos, ticket médio menor) versus o vendedor de **valor** (poucos pedidos, alto ticket por venda).

> 💡 **Insight encontrado:** O vendedor com o maior volume de pedidos **não é** o mesmo que gerou o maior faturamento. Isso revela que o topo do ranking de receita foi alcançado por poucos negócios de alto valor — um perfil estratégico diferente do que o volume bruto de pedidos sugere. Essa distinção é crítica para definir metas, modelos de bonificação e estratégias de prospecção por perfil de vendedor.

**Query:**

```sql
-- Cole aqui a sua consulta SQL
```

**Resultado:**

```
-- Cole aqui o output da consulta
```

---

### Pergunta 4 — Quais vendedores lideram em receita de Technology e Furniture? Existe algum concentrado apenas em Office Supplies de baixo valor?

**Objetivo:** Mapear o mix de categorias por vendedor para identificar se há profissionais sub-aproveitados em produtos de maior margem e complexidade de venda.

**Query:**

```sql
-- Cole aqui a sua consulta SQL
```

**Resultado:**

```
-- Cole aqui o output da consulta
```

---

### Pergunta 5 — Vendedores mais antigos (antes de 2014) performam melhor do que os contratados recentemente (2015–2017)?

**Objetivo:** Avaliar o retorno sobre o investimento em treinamento e tempo de rampa, comparando a performance de duas coortes de senioridade por volume de vendas e ticket médio.

> 💡 **Insight encontrado:** O grupo de vendedores mais recentes supera o grupo mais antigo em **quantidade de vendas**. Porém, ambos os grupos mantêm **exatamente o mesmo ticket médio por vendedor**. Isso indica que o programa de treinamento está sendo eficaz na capacitação técnica (qualidade das vendas equivalente), mas que a experiência acumulada dos mais antigos não se traduz em negócios de maior valor individual — um dado relevante para revisão de estratégia de up-sell e desenvolvimento de carreira.

**Query:**

```sql
-- Cole aqui a sua consulta SQL
```

**Resultado:**

```
-- Cole aqui o output da consulta
```

---

## 🎯 Resultados Obtidos & Impacto

Este projeto entrega valor concreto para três frentes da organização:

**Área Financeira — Precisão e Auditabilidade no Pagamento de Comissões**
O cálculo de comissões deixa de ser um processo manual e suscetível a erros. A lógica `CASE WHEN` aplicada diretamente na query garante que cada categoria receba o percentual correto, com resultado rastreável e auditável. O time financeiro passa a ter um processo reproduzível e confiável para fechamento mensal.

**Área Comercial — Transparência e Fairness nas Metas**
Ao separar os rankings de volume e faturamento, gestores conseguem reconhecer diferentes perfis de alta performance com justiça. Vendedores de alto valor e vendedores de alto volume têm métricas próprias — o que evita desmotivação e permite construção de metas mais inteligentes por perfil.

**Gestão de Pessoas — Diagnóstico do Programa de Treinamento**
A análise por coorte de senioridade fornece um dado objetivo: novos colaboradores vendem em maior quantidade com o mesmo ticket médio dos veteranos. Isso é evidência de que o onboarding funciona na dimensão técnica, mas abre uma agenda clara de desenvolvimento para elevar o valor médio por negócio — dado que pode embasar decisões de treinamento, coaching e estrutura de incentivos.

---

## 🚀 Como Executar

**Pré-requisitos:** PostgreSQL instalado localmente ou acesso a um ambiente cloud (ex: ElephantSQL, Supabase, Railway).

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/seu-repositorio.git

# 2. Acesse a pasta do projeto
cd seu-repositorio

# 3. Importe as tabelas no seu banco PostgreSQL
psql -U seu_usuario -d seu_banco -f schema/tabela_vendas.sql
psql -U seu_usuario -d seu_banco -f schema/tabela_vendedores.sql

# 4. Execute as queries na pasta /queries em ordem numérica
```

---

## 👤 Autor

Feito com 🎯 por **[Seu Nome]**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com/in/seu-perfil)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/seu-usuario)

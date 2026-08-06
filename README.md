# E-commerce SQL Analytics Database

## About the project

This project is a practice project where I designed and built a relational database for an e-commerce system using MySQL 8.0+.

The main goal of this project is to practice:

* database design
* SQL queries
* data analysis
* query optimization
* working with relational data

The database represents a simple e-commerce system with customers, products, orders, and payments.

The project shows how transactional data can be stored, validated, analyzed, and used for business reports.

---

## Project structure

```
.
├── schema.sql
├── seed.sql
├── verify.sql
├── data-generator/
│   ├── README.md
│   ├── requirements.txt
│   └── generate_data.py
├── docs/
│   └── er_diagram.png
├── queries/
│   ├── 01_basic.sql
│   ├── 02_joins.sql
│   ├── 03_grouping.sql
│   ├── 04_subqueries.sql
│   ├── 05_cte.sql
│   ├── 06_window_functions.sql
│   └── 07_optimization.md
└── README.md
```

---

# Database Schema

The database was created using a relational database model.

ER diagram:

![ER Diagram](docs/er_diagram.png)

The main relationships:

* One customer can have many orders
* One order can contain many products
* Products belong to categories
* Orders can have payments

---

# SQL Practice

## Basic Queries

File:

```
queries/01_basic.sql
```

Topics:

* SELECT
* WHERE
* ORDER BY
* LIMIT
* DISTINCT
* LIKE
* BETWEEN
* string functions
* numeric functions

---

## JOIN Queries

File:

```
queries/02_joins.sql
```

Topics:

* INNER JOIN
* LEFT JOIN
* multiple table joins


---

## Grouping and Aggregation

File:

```
queries/03_grouping.sql
```

Topics:

* COUNT
* SUM
* AVG
* MIN
* MAX
* GROUP BY
* HAVING


---

## Subqueries

File:

```
queries/04_subqueries.sql
```

Topics:

* simple subqueries
* correlated subqueries
* EXISTS
* NOT EXISTS


---

## Common Table Expressions (CTE)

File:

```
queries/05_cte.sql
```

Topics:

* WITH statements
* reusable query blocks
* building reports step by step


---

## Window Functions

File:

```
queries/06_window_functions.sql
```

Topics:

* ROW_NUMBER
* RANK
* DENSE_RANK
* LAG
* LEAD
* aggregate window functions


---

# Query Optimization

File:

```
queries/07_optimization.md
```

This section focuses on database performance.

Practiced:

* creating indexes
* checking execution plans
* using EXPLAIN
* understanding how MySQL uses indexes


---


# Data Verification

File:

```
verify.sql
```

This file checks database consistency after inserting data.

It verifies:

* table record counts
* missing relationships
* duplicate emails
* duplicate product SKU
* incorrect order totals
* invalid stock values
* payments without orders

The goal is to make sure the database keeps correct and consistent data.

---

# Database Features

The project includes:

* primary keys
* foreign keys
* unique constraints
* check constraints
* indexes
* timestamps
* data consistency checks

---

# Technologies

* MySQL 8.0+
* SQL
* Python
* Git

---

# What I learned

During this project I practiced:

* designing a relational database
* creating database schemas
* writing complex SQL queries
* working with joins and aggregations
* using CTE and window functions
* analyzing query performance with EXPLAIN

This project is part of my learning process to improve my SQL and backend development skills.
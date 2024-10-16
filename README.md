# ELT-Pipeline

This project implements an ELT (Extract, Load, Transform) pipeline using dbt (data build tool) with Snowflake as the data warehouse and Apache Airflow for orchestration.

data_pipeline/
├── dbt_project.yml
├── models/
│   ├── staging/
│   │   ├── tpch_sources.yml
│   │   ├── stg_tpch_orders.sql
│   │   └── stg_tpch_line_items.sql
│   └── marts/
│       ├── int_order_items.sql
│       ├── fct_orders.sql
│       └── generic_tests.yml
├── macros/
│   └── pricing.sql
├── tests/
│   ├── fct_orders_discount.sql
│   └── fct_orders_date_valid.sql
└── dbt_dag.py


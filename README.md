# ELT Pipeline with dbt, Snowflake, and Airflow

This project demonstrates an ELT pipeline using **dbt**, **Snowflake**, and **Apache Airflow**. The pipeline extracts data from Snowflake, transforms it with dbt, and orchestrates tasks with Airflow.

## Project Overview

The pipeline performs:
- **Extraction**: Data from Snowflake’s TPCH sample dataset.
- **Transformation**: Staging and transforming raw data into analytics-ready tables with dbt.
- **Testing**: Data quality checks using dbt tests.
- **Orchestration**: Scheduling and automation using Airflow.

## Project Structure

```bash
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
```

### Key Files:

- `dbt_project.yml`: dbt configuration file.
- `models/`: Contains staging and mart models for transforming data.
  - `staging/`: Includes source definitions and staging transformations.
  - `marts/`: Aggregated models, including intermediate and fact tables.
- `macros/pricing.sql`: dbt macros to standardize transformation logic.
- `tests/`: Contains custom tests for data quality validation.
- `dbt_dag.py`: Airflow DAG to orchestrate the dbt pipeline.

### Example Code:

- **Source Definition (`tpch_sources.yml`)**:
  
  ```yaml
  version: 2

  sources:
    - name: tpch
      database: snowflake_sample_data
      schema: tpch_sf1
      tables:
        - name: orders
          columns:
            - name: o_orderkey
              tests:
                - unique
                - not_null
        - name: lineitem
          columns:
            - name: l_orderkey
              tests:
                - relationships:
                    to: source('tpch', 'orders')
                    field: o_orderkey
  ```

- **Staging Model (`stg_tpch_orders.sql`)**:
  
  ```sql
  select
      o_orderkey as order_key,
      o_custkey as customer_key,
      o_orderstatus as status_code,
      o_totalprice as total_price,
      o_orderdate as order_date
  from
      {{ source('tpch', 'orders') }}
  ```

- **Macro (`pricing.sql`)**:

  ```sql
  {% macro discounted_amount(extended_price, discount_percentage, scale=2) %}
      (-1 * {{ extended_price }} * {{ discount_percentage }})::decimal(16, {{ scale }})
  {% endmacro %}
  ```

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/data_pipeline.git
   cd data_pipeline
   ```

2. Install dependencies:

   - **dbt**: Make sure you have `dbt-snowflake` installed.
   
     ```bash
     pip install dbt-snowflake
     ```

   - **Airflow**: Ensure Airflow is installed with required providers:

     ```bash
     pip install apache-airflow
     pip install astronomer-cosmos apache-airflow-providers-snowflake
     ```

3. Set up your Snowflake credentials in the Airflow UI by adding a new connection (`snowflake_conn`).

## How to Run

1. Set up the Snowflake environment by running the provided SQL script (see README section "Step 1: Snowflake Environment Setup").
2. Run dbt models:

   ```bash
   dbt run
   ```

3. To test the models, run:

   ```bash
   dbt test
   ```

4. Deploy and run the Airflow DAG:

   - Place `dbt_dag.py` in the `dags/` folder of your Airflow instance.
   - Start the Airflow scheduler and webserver:

     ```bash
     airflow scheduler
     airflow webserver
     ```

5. The DAG will run daily, orchestrating the dbt transformations and tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

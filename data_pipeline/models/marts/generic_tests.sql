models: 
    -name: fct_order
    -columns:
        -name: order_date
        -tests:    
            -unique
            -not_null
            -relationships:
                -to: ref('stg_tpch_orders')
                -field: order_key
                -severity: warn
            -name: customer_key
            -tests:
                -accepted_values:
                    values: ['P', 'O', 'F']
            




    
            

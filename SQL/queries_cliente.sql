
### Quantos clientes estão registrados em cada estado?
SELECT state,COUNT(customer_id) AS NUM_CLIENTES FROM customers_table GROUP BY state;

# Quais cidades têm o maior número de clientes?
SELECT city,state,COUNT(customer_id) AS NUM_CLIENTES FROM customers_table GROUP BY city,state ORDER BY NUM_CLIENTES DESC;

## Quais clientes fizeram mais pedidos no último ano?
WITH pedidos_clientes_ano AS (SELECT
 OT.customer_id,CONCAT(CUSTM.first_name," ",CUSTM.last_name) AS NOME_CLIENTE,
 DATE_FORMAT(order_date,'%Y') AS ANO,
 COUNT(OT.order_id) as NUM_PEDIDOS
 FROM orders_table OT 
 LEFT JOIN customers_table CUSTM ON CUSTM.customer_id=OT.customer_id  
 GROUP BY customer_id,NOME_CLIENTE,ANO)
 SELECT * FROM pedidos_clientes_ano WHERE ANO='2018' AND NUM_PEDIDOS>2;

# Qual é o valor médio gasto por cliente em cada pedido? 
SELECT * FROM order_items_table;
SELECT OITEMS.order_id,
CONCAT(CUSTM.first_name," ",CUSTM.last_name) AS NOME_CLIENTE,
ROUND(AVG((OITEMS.list_price)-(OITEMS.discount * OITEMS.list_price))) AS GASTO_MEDIO
FROM order_items_table OITEMS 
LEFT JOIN orders_table OT ON OT.order_id=OITEMS.order_id
LEFT JOIN customers_table CUSTM ON CUSTM.customer_id=OT.customer_id
GROUP BY OITEMS.order_id,NOME_CLIENTE
ORDER BY GASTO_MEDIO DESC;




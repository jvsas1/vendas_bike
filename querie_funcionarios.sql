### Analise dos Funcionários

# Quantos funcionários trabalham em cada loja?
SELECT STF.store_id,ST.store_name AS NOME_LOJA, COUNT(STF.staff_id) AS NUM_FUNCIONARIOS FROM staffs_table STF LEFT JOIN stores_table ST ON ST.store_id=STF.store_id GROUP BY store_id,NOME_LOJA;


#Das demandas ministradas por cada funcionário, quais foram os funcionários que não apresentaram nenhuma demanda no seu nome?
SELECT 
STF.staff_id,
CONCAT(STF.first_name," ",STF.last_name) AS NOME_FUNCIONÁRIO,
COUNT(OT.order_id) as NUM_PEDIDOS FROM staffs_table STF LEFT JOIN orders_table OT ON OT.staff_id=STF.staff_id 
GROUP BY STF.staff_id,NOME_FUNCIONÁRIO;

## Qual é o desempenho dos funcionários em termos de vendas?
SELECT 
STF.staff_id,
CONCAT(STF.first_name," ",STF.last_name) AS NOME_FUNCIONÁRIO,
SUM(OITEMS.quantity) AS QUANTIDADE_ITENS_VENDIDOS,
SUM(ROUND(((OITEMS.list_price)-(OITEMS.discount * OITEMS.list_price) )*(OITEMS.quantity),2)) AS TOTAL
FROM order_items_table OITEMS 
LEFT JOIN products_table PROD ON PROD.product_id=OITEMS.product_id 
LEFT JOIN orders_table OT ON OT.order_id=OITEMS.order_id
LEFT JOIN staffs_table STF ON STF.staff_id=OT.staff_id
GROUP BY STF.staff_id,NOME_FUNCIONÁRIO;







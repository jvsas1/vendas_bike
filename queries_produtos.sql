### ANALISE DE PRODUTOS e PEDIDOS ###

# Qual é o número de pedidos feitos em diferentes períodos:
# Por ano?
SELECT DATE_FORMAT(order_date,'%Y') AS ANO,COUNT(order_id) FROM orders_table  GROUP BY ANO;
# Por mês? 
SELECT DATE_FORMAT(order_date,'%Y') AS ANO,DATE_FORMAT(order_date,'%m') AS MES,COUNT(order_id) FROM orders_table  GROUP BY ANO,MES ORDER BY ANO,MES;

# Qual é o tempo de envio médio da entrega dos pedidos?
SELECT COUNT(*) AS TOTAL_PEDIDOS,ROUND(AVG(DATEDIFF(shipped_date,order_date))) as TEMPO_ENVIO FROM orders_table;


# Quantos pedidos estão atrasados? (Diferença entre data solicitada e data de envio) 
WITH entregas_atrasos AS (SELECT order_id,(DATEDIFF(shipped_date,required_date)) as DIF_ENVIO_REQUIRED FROM orders_table GROUP BY order_id)
SELECT COUNT(*) AS PEDIDOS_ATRASADOS FROM entregas_atrasos WHERE DIF_ENVIO_REQUIRED>0;

# Lista de produtos + marca + categoria
SELECT
 PROD.product_id,
 PROD.product_name AS NOME_PRODUTO,
 CATG.category_name AS CATEGORIA,
 BRAND.brand_name AS MARCA,
 PROD.model_year AS ANO_MODELO,
 PROD.list_price AS PRECO_UNITARIO
FROM products_table PROD 
LEFT JOIN categories_table CATG ON CATG.category_id=PROD.category_id
LEFT JOIN brands_table BRAND ON BRAND.brand_id=PROD.brand_id ;

# Preço médio de bicicleta por categoria
SELECT 
CATG.category_id,
CATG.category_name AS CATEGORIA,
 ROUND(AVG(PROD.list_price),2) AS PRECO_MEDIO
FROM products_table PROD 
LEFT JOIN categories_table CATG ON CATG.category_id=PROD.category_id
GROUP BY CATG.category_id
ORDER BY PRECO_MEDIO DESC;

# Preço médio de bicicleta por  marca
SELECT 
BRAND.brand_id,
BRAND.brand_name AS MARCA,
ROUND(AVG(PROD.list_price),2) AS PRECO_MEDIO
FROM products_table PROD 
LEFT JOIN brands_table BRAND ON BRAND.brand_id=PROD.brand_id
GROUP BY BRAND.brand_id
ORDER BY PRECO_MEDIO DESC;


### Vendas por produto
SELECT 
OITEMS.order_id,
PROD.product_name AS PRODUTO,
OITEMS.quantity AS QUANTIDADE,
OITEMS.list_price AS PRECO_UNITARIO,
OITEMS.discount AS PERC_DESCONTO,
ROUND((OITEMS.discount * OITEMS.list_price),2) AS VALOR_DESCONTO,
ROUND((OITEMS.list_price)-(OITEMS.discount * OITEMS.list_price),2) AS PRECO_FINAL,
ROUND(((OITEMS.list_price)-(OITEMS.discount * OITEMS.list_price) )*(OITEMS.quantity),2) AS TOTAL
FROM order_items_table OITEMS LEFT JOIN products_table PROD ON PROD.product_id=OITEMS.product_id;

# Qual é o total de vendas para cada marca?
SELECT 
BRAND.brand_name AS MARCA,
SUM(OITEMS.quantity) AS QUANTIDADE_TOTAL,
ROUND(SUM(ROUND(((OITEMS.list_price)-(OITEMS.discount * OITEMS.list_price) )*(OITEMS.quantity),2)),2) AS TOTAL_VENDA
FROM order_items_table OITEMS 
LEFT JOIN products_table PROD ON PROD.product_id=OITEMS.product_id
LEFT JOIN brands_table BRAND ON BRAND.brand_id=PROD.brand_id
GROUP BY BRAND.brand_name
ORDER BY TOTAL_VENDA DESC;

# Quais produtos têm o maior estoque disponível em cada loja?
WITH Ranking_estoque_loja AS 
(SELECT 
STOCK.store_id,
STOCK.product_id, 
STRS.store_name AS LOJA,
PROD.product_name AS PRODUTO_NOME,
STOCK.quantity AS ESTOQUE,
DENSE_RANK() OVER(PARTITION BY store_id  ORDER BY quantity DESC) AS ESTOQUE_RANKING 
FROM stocks_table STOCK
LEFT JOIN products_table PROD ON PROD.product_id=STOCK.product_id
LEFT JOIN stores_table STRS ON STRS.store_id=STOCK.store_id

)
SELECT * FROM Ranking_estoque_loja WHERE ESTOQUE_RANKING=1 ; 




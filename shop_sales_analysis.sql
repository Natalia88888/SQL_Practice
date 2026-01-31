-- ЗАДАЧА: Анализ эффективности магазинов торговой сети
-- Цель: Вычислить общую выручку, долю каждого магазина в сети 
-- и отфильтровать магазины с выручкой выше средней.

-- Используем CTE (обобщенное табличное выражение) для чистоты кода
WITH ShopTotals AS (
    SELECT 
        shop_name,
        SUM(amount) as total_revenue
    FROM sales
    GROUP BY shop_name
)
SELECT 
    shop_name,
    total_revenue,
    -- 1. Оконная функция: считаем процент от общей выручки всей сети
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER(), 2) as percent_of_total_network,
    
    -- 2. Подзапрос: выводим среднюю выручку по сети для сравнения
    (SELECT ROUND(AVG(total_revenue), 2) FROM ShopTotals) as network_average_revenue
FROM ShopTotals
-- 3. Фильтрация: оставляем только магазины-лидеры (выше среднего)
WHERE total_revenue > (SELECT AVG(total_revenue) FROM ShopTotals)
ORDER BY total_revenue DESC;

-- このファイルに回答を記述してください
CREATE OR REPLACE FUNCTION summarize_daily_sales(target_date DATE)
RETURNS void AS $$
BEGIN
    -- 指定日のデータを削除（再集計時に重複しない）
    DELETE FROM daily_sales_summary WHERE summary_date = target_date;

    -- 集計してINSERT
    INSERT INTO daily_sales_summary (
        summary_date,
        product_id,
        total_quantity_sold,
        total_sales_amount
    )
    SELECT
        target_date,
        od.product_id,
        SUM(od.quantity) AS total_quantity,
        SUM(od.quantity * p.price) AS total_amount
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    WHERE o.order_datetime::date = target_date
    GROUP BY od.product_id;
END;
$$ LANGUAGE plpgsql;

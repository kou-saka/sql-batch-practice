-- このファイルに回答を記述してください
CREATE OR REPLACE FUNCTION summarize_daily_sales(target_date DATE)
RETURNS void AS $$
DECLARE
    product_record RECORD;
BEGIN
    RAISE NOTICE '集計開始: %', target_date;

    DELETE FROM daily_sales_summary WHERE summary_date = target_date;

    FOR product_record IN
        SELECT
            d.product_id,
            SUM(d.quantity) AS total_quantity,
            SUM(d.quantity * p.price) AS total_sales
        FROM orders o
        JOIN order_details d ON o.order_id = d.order_id
        JOIN products p ON d.product_id = p.product_id
        WHERE DATE(o.order_datetime) = target_date
        GROUP BY d.product_id
    LOOP
        INSERT INTO daily_sales_summary (
            summary_date, product_id, total_quantity_sold, total_sales_amount
        ) VALUES (
            target_date, product_record.product_id,
            product_record.total_quantity, product_record.total_sales
        );
    END LOOP;

    RAISE NOTICE '集計終了: %', target_date;
END;
$$ LANGUAGE plpgsql;
-- このファイルに回答を記述してください
CREATE OR REPLACE FUNCTION generate_test_data(start_date DATE, end_date DATE)
RETURNS void AS $$
DECLARE
    target_date DATE;
    i INT;
    new_order_id INT;
    product RECORD;
BEGIN
    target_date := start_date;

    WHILE target_date <= end_date LOOP

        FOR i IN 1..3 LOOP
            INSERT INTO orders (order_datetime)
            VALUES (target_date + (i * INTERVAL '3 hours'))
            RETURNING order_id INTO new_order_id;

            FOR product IN
                SELECT * FROM products ORDER BY random() LIMIT floor(random()*3 + 1)
            LOOP
                INSERT INTO order_details (order_id, product_id, quantity)
                VALUES (
                    new_order_id,
                    product.product_id,
                    floor(random() * 5 + 1)
                );
            END LOOP;
        END LOOP;

        target_date := target_date + INTERVAL '1 day';
    END LOOP;
END;
$$ LANGUAGE plpgsql;

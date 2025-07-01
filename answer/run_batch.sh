#!/bin/bash
# ここに回答を記述してください
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <target_date>"
  exit 1
fi

TARGET_DATE=$1
CONTAINER_NAME=sql-batch-practice-db
CSV_PATH="/output/${TARGET_DATE}.csv"
LOCAL_PATH="./output/${TARGET_DATE}.csv"

# 集計関数の実行
docker exec -i "$CONTAINER_NAME" psql -U postgres -d practice_db -c "SELECT summarize_daily_sales('$TARGET_DATE');"

# CSVファイルをコンテナ内で出力
docker exec "$CONTAINER_NAME" bash -c "psql -U postgres -d practice_db -c \"
COPY (
  SELECT * FROM daily_sales_summary
  WHERE summary_date = '$TARGET_DATE'
) TO '$CSV_PATH' WITH CSV HEADER;
\""

# コンテナからホストへコピー
docker cp "${CONTAINER_NAME}:${CSV_PATH}" "$LOCAL_PATH"
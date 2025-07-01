#!/bin/bash
# このファイルに回答を記述してください
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <start_date> <end_date>"
  exit 1
fi

START_DATE=$1
END_DATE=$2

# コンテナ名
CONTAINER_NAME=sql-batch-practice-db

# psqlでPostgreSQLコンテナに接続
docker exec -i "$CONTAINER_NAME" psql -U postgres -d practice_db <<EOF
SELECT generate_test_data('$START_DATE', '$END_DATE');
EOF
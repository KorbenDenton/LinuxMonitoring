#!/bin/bash

for i in {1..5}; do
    DATE=$(date -d "-$i days" "+%d/%b/%Y")
    LOGFILE="nginx_log_$(date -d "-$i days" "+%Y-%m-%d").log"

     REC_NUM=$(( RANDOM % 901 + 100 ))

    echo "Генерируется $REC_NUM записей в $LOGFILE..."

    > "$LOGFILE"  # Очищаем файл перед записью

    for ((j = 0; j < REC_NUM; j++)); do
        IP="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"

        METHODS=("GET" "POST" "PUT" "PATCH" "DELETE")
        METHOD=${METHODS[RANDOM % ${#METHODS[@]}]}

        CODES=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
        STATUS=${CODES[RANDOM % ${#CODES[@]}]}

        SIZE=$((RANDOM % 4801 + 200))

        URLS=("/docs" "/index.html" "/api/data" "/product/123" "/contact" "/about" "/search?q=linux" "/admin" "/profile" "/cart")
        URL=${URLS[RANDOM % ${#URLS[@]}]}

        AGENTS=("Mozilla/5.0" "Google Chrome/91.0" "Opera/80.0" "Safari/537.36" "Internet Explorer/11.0" "Microsoft Edge/88.0" "Crawler and bot" "Library and net tool")
        AGENT=${AGENTS[RANDOM % ${#AGENTS[@]}]}

        HOURS=$(printf "%02d" $((RANDOM % 24)))
        MINUTES=$(printf "%02d" $((RANDOM % 60)))
        SECONDS=$(printf "%02d" $((RANDOM % 60)))

        TIMESTAMP="[$DATE:$HOURS:$MINUTES:$SECONDS +0000]"

        echo "$IP - - $TIMESTAMP \"$METHOD $URL HTTP/1.1\" $STATUS $SIZE \"-\" \"$AGENT\"" >> "$LOGFILE"
    done

    echo "Файл $LOGFILE создан."
done


# Код	Значение
# 200	OK — успешный запрос.
# 201	Created — ресурс создан.
# 400	Bad Request — некорректный запрос.
# 401	Unauthorized — требуется авторизация.
# 403	Forbidden — доступ запрещен.
# 404	Not Found — страница не найдена.
# 500	Internal Server Error — внутренняя ошибка сервера.
# 501	Not Implemented — сервер не поддерживает метод.
# 502	Bad Gateway — плохой шлюз (проблемы с проксированием).
# 503	Service Unavailable — сервис временно недоступен.

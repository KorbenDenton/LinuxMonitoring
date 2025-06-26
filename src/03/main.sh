#!/bin/bash

source ./del_by_log.sh
source ./del_by_time.sh
source ./del_by_mask.sh

if [[ "$#" -ne 1 || ! "$1" =~ ^[1-3]$ ]]; then
    echo "Ошибка. Должен быть задан ровно один параметр от 1 до 3, обозначающий режим работы:"
    echo "1 — очистка по лог-файлу"
    echo "2 — очистка по дате и времени создания"
    echo "3 — очистка по маске имени"
    exit 1
fi

choice="$1"

case "$choice" in
    1) del_by_log ;;
    2) del_by_time ;;
    3) del_by_mask ;;
esac



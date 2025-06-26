#!/bin/bash

source ./generate_name.sh
source ./generate_files.sh
source ./check_free_space.sh
source ./choice_folder.sh

if [[ "$#" -ne 3 ]]; then
   echo "Ошибка. Задайте три параметра"
   exit 1
fi


FOLDER_CHARS="$1"
FILE_CHARS="$2"
FILE_SIZE="$3"

DATE_FOR_LOG=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$HOME/logs/log_${DATE_FOR_LOG}.txt"

START_TIME=$(date +%s)
START_HUMAN=$(date +"%Y-%m-%d %H:%M:%S")
echo "===Скрипт начат: $START_HUMAN===" >> "$LOG_FILE"

if [[ ! "$FOLDER_CHARS" =~ ^[a-zA-Z]{1,7}$ ]]; then
   echo "Ошибка. Названия папок должны содержать только латинские буквы и не более 7 знаков"
   exit 1
fi

if [[ ! "$FILE_CHARS" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
   echo "Ошибка. Названия файлов и их расширения должны содержать только латинские буквы, а также не более 7 знаков для названия файлов и не более 3 знаков для расширений"
   exit 1
fi

FILE_NAME="${FILE_CHARS%.*}"
FILE_EXT="${FILE_CHARS#*.}"

if [[ "$FILE_SIZE" =~ ^[0-9]+Mb$ ]]; then
   SIZE="${FILE_SIZE%Mb}"
    if [[ "$SIZE" -le 0 ]]; then
      echo "Ошибка. Размер файла не может быть 0MB"
      exit 1
    elif [[ "$SIZE" -gt 100 ]]; then
      echo "Ошибка. Размер файла не должен превышать 100MB"
      exit 1
    fi
else
    echo "Ошибка. Задан некорректный формат размера"
    exit 1
fi

if [ ! -x "./generate_name.sh" ] || [ ! -x "./choice_folder.sh" ] || [ ! -x "./generate_files.sh" ] || [ ! -x "./check_free_space.sh" ] ; then
    echo "Ошибка. Отсутствуют необходимые скрипты или нет прав на их выполнение"
    exit 1
fi


mapfile -t bin_folders < <(echo "$PATH" | tr ':' '\n' | grep -E '/(s)?bin')


folder_count=0

while [ $(check_free_space) -eq 0 ]; do
    is_bin=0
    folder="$(choice_folder)"

    for bin_folder in "${bin_folders[@]}"; do
        if [[ "$folder" == "$bin_folder" ]]; then
            is_bin=1
            break
        fi
    done
    if [[ $is_bin -eq 1 ]]; then continue; fi

    new_folder="$(generate_name "$FOLDER_CHARS")"
    path_to_folder="$folder/$new_folder"

    if ! mkdir -p "$path_to_folder"; then
        echo "Ошибка: не удалось создать папку $path_to_folder."
        exit 1
    fi

    echo "folder $path_to_folder $(date +"%Y-%m-%d %H:%M:%S")" >> "$LOG_FILE"

    folder_count=$((folder_count + 1))
    file_count=$((RANDOM % 5 + 1))

    if [ "$folder_count" -eq 100 ]; then
        while [ $(check_free_space) -eq 0 ]; do
            generate_files
        done
    fi

    for ((i = 0; i < file_count; i++)); do
        if [ $(check_free_space) -ne 0 ]; then continue; fi
        generate_files
    done
done


END_TIME=$(date +%s)
END_HUMAN=$(date +"%Y-%m-%d %H:%M:%S")
ELAPSED=$((END_TIME - START_TIME))

# Форматируем длительность в ЧЧ:ММ:СС
ELAPSED_FMT=$(printf '%02d:%02d:%02d' $((ELAPSED/3600)) $(( (ELAPSED%3600)/60 )) $((ELAPSED%60)))

echo "===Скрипт завершён: $END_HUMAN===" >> "$LOG_FILE"
echo "===Общее время выполнения: $ELAPSED_FMT====" >> "$LOG_FILE"

echo -e "Создание завершено. Лог: $LOG_FILE"
echo -e "Время начала: $START_HUMAN"
echo -e "Время окончания: $END_HUMAN"
echo -e "Общее время выполнения: $ELAPSED_FMT"

exit 0

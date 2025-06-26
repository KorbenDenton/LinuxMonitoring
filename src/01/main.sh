#!/bin/bash

source ./check_free_space.sh
source ./generate_name.sh

#validate
if [[ "$#" -ne 6 ]]; then
    echo "Ошибка. Скрипт требует 6 параметров!"
    exit 1
fi

DIR="$1"          # Абсолютный путь к директории
FOLDERS="$2"      # Количество вложенных папок
FOLDER_CHARS="$3" # Символы для имени папок (макс. 7 символов)
FILES="$4"        # Количество файлов в каждой папке
FILE_CHARS="$5"   # Символы для имени файлов и их расширений
FILE_SIZE="$6"    # Размер файлов в КБ

if [[ "$(realpath -- "$DIR")" != "$DIR" ]]; then
   echo "Ошибка. Задайте абсолютный путь, начинающийся с '/'"
   exit 1
fi


if ! [[ "$FOLDERS" =~ ^[0-9]+$ ]] || (( FOLDERS < 1  )); then
   echo "Ошибка. Количество файлов должно быть обозначено цифрами и не должно быть нулевым"
   exit 1
fi


if [[ ! "$FOLDER_CHARS" =~ ^[a-zA-Z]{1,7}$  ]]; then
   echo "Ошибка. Названия папок должны содержать только латинские буквы и не более 7 знаков"
   exit 1
fi


if [[ ! "$FILE_CHARS" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
   echo "Ошибка. Названия файлов и их расширения должны содержать только латинские буквы, а также не более 7 знаков для названия файлов и не более 3 знаков для расширений"
   exit 1
fi

FILE_NAME="${FILE_CHARS%.*}"
FILE_EXT="${FILE_CHARS#*.}"

if [[ "$FILE_SIZE" =~ ^[0-9]+kb$ ]]; then
   SIZE="${FILE_SIZE%kb}"
    if [[ "$SIZE" -le 0 ]]; then
      echo "Ошибка. Размер файла не может быть нулевым"
      exit 1
    elif [[ "$SIZE" -gt 100 ]]; then
      echo "Ошибка. Размер файла не должен превышать 100КБ"
      exit 1
    fi
else
    echo "Ошибка. Задан некорректный формат размера"
    exit 1
fi

mkdir -p "$DIR"
log_date=$(date +"%Y-%m-%d %H:%M:%S")
log_file="$DIR/log_${log_date}.txt"
echo "Журнал создания файлов и папок" > "$log_file"
#generate_dir
mkdir -p "$DIR"

for (( i=0;i<FOLDERS; i++ )); do
   check_free_space

   folder_name=$(generate_name "$FOLDER_CHARS")
   folder_path="$DIR/$folder_name"
   mkdir -p "$folder_path"

   for (( j=0; j<FILES; j++ )); do
      check_free_space

      file_name=$(generate_name "$FILE_NAME")."$FILE_EXT"
      file_path="$folder_path/$file_name"

      head -c "${SIZE}K" </dev/urandom > "$file_path"

      echo "$file_path, $(date +"%Y-%m-%d %H:%M:%S"), ${SIZE}KB" >> "$log_file"

   done

done

echo "Создание лога завершено. Лог: $log_file"

exit 0

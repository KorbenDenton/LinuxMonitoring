function del_by_log {
   read -e -p "Укажите путь к требуемому лог файлу: " LOG_FILE
   if [[ ! -f "$LOG_FILE" ]]; then
      echo "Ошибка. Лог файл не найден"
      exit 1
   fi

   grep "^file " "$LOG_FILE" | while IFS= read -r line; do
      file_path=$(echo "$line" | awk '{print $2}')
      if [[ -f "$file_path" ]]; then
         rm -f "$file_path"
         echo "Удален файл: $file_path"
      fi
   done


   grep "^folder " "$LOG_FILE" | tac | while IFS= read -r line; do
      folder_path=$(echo "$line" | awk '{print $2}')
      if [[ -d "$folder_path" ]]; then
          rmdir --ignore-fail-on-non-empty "$folder_path" 2>/dev/null || rm -rf "$folder_path"
          echo "Удалена папка: $folder_path"
      fi
   done

   echo "Очистка завершена."
}

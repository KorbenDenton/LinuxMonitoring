source ./generate_name.sh

function generate_files {
   local filename
   local filepath
   filename=$(generate_name "$FILE_NAME")."$FILE_EXT"
   filepath="$path_to_folder/$(basename "$filename")"

   head -c "${SIZE}M" </dev/urandom > "$filepath"
   echo "file $filepath $(date +"%Y-%m-%d %H:%M:%S") ${SIZE}MB" >> "$LOG_FILE"
}

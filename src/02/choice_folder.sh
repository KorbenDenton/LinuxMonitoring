function choice_folder {
  folders=($(ls -la | grep ^d | awk '{print $9}'))
  random_index=$((RANDOM % ${#folders[@]}))
  folder="${folders[$random_index]}"

  path="$(pwd)/${folder}"
  echo "$path"
}

function check_free_space {
  local min_size=1
  local disk_space=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')

  if [[ "$disk_space" -le "$min_size" ]]; then
        echo 1
  else
        echo 0
  fi
}


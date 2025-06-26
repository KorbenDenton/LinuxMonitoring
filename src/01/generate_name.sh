function generate_name {
 current_date=$(date +"%d%m%y")
 chars="$1"
 name=""
 length=${#chars}
 for (( i=0; i<length; i++ )); do
    if [[ $i -eq 0 ]]; then 
       char_count=$(( RANDOM % 3 + 3))
       name+=$(printf "%-${char_count}s" "" | tr ' ' "${chars:$i:1}")
    else
       char_count=$(( RANDOM % 8 + 1))
       name+=$(printf "%-${char_count}s" "" | tr ' ' "${chars:$i:1}")
    fi
 done
 echo "${name}_$current_date"
}

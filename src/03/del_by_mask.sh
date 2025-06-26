function del_by_mask {
     #Удаление папок
     sudo find / \
        -path "/proc" -prune -o \
        -path "/sys" -prune -o \
        -path "/dev" -prune -o \
        -path "/run" -prune -o \
        -path "/bin" -prune -o \
        -path "/boot" -prune -o \
        -path "/etc" -prune -o \
        -path "/lib" -prune -o \
        -path "/lib32" -prune -o \
        -path "/lib64" -prune -o \
        -path "/usr" -prune -o \
        -path "/var" -prune -o \
        -path "/sbin" -prune -o \
        -depth -name "*_$(date +"%d%m%y")" \
        -exec rm -r {} \; -exec echo "Удалена папка: {}" \;
     echo "Очистка завершена."
}

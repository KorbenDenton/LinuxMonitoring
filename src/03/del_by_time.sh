function del_by_time {
    echo "Введите начало периода в формате YYYY-MM-DD HH:MM:SS:"
    read start_time

    echo "Введите конец периода в формате YYYY-MM-DD HH:MM:SS:"
    read end_time

    #Удаление файлов
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
        -type f -newermt "$start_time" ! -newermt "$end_time" \
        -exec echo "Удален файл: {}" \; -exec rm -f {} +

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
        -type d -newermt "$start_time" ! -newermt "$end_time" \
        -exec echo "Удалена папка: {}" \; -exec rm -rf {} +

     echo "Очистка завершена."
}

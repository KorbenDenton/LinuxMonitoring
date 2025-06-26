#!/bin/bash

METRICS_FILE="/var/www/html/my_node_metrics"

while true; do
    # CPU Load (1 min average)
    CPU_LOAD=$(awk '{print $1}' /proc/loadavg)

    # Memory info
    MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')   # in KB
    MEM_FREE=$(grep MemAvailable /proc/meminfo | awk '{print $2}') # in KB

    # Disk space (root fs)
    DISK_TOTAL=$(df / | awk 'NR==2 {print $2}')  # in KB
    DISK_FREE=$(df / | awk 'NR==2 {print $4}')   # in KB

    # Write to file in Prometheus format
    cat <<EOF > "$METRICS_FILE"
# HELP my_cpu_load_1min 1-minute load average
# TYPE my_cpu_load_1min gauge
my_cpu_load_1min $CPU_LOAD

# HELP my_memory_total_kb Total memory in KB
# TYPE my_memory_total_kb gauge
my_memory_total_kb $MEM_TOTAL

# HELP my_memory_free_kb Available memory in KB
# TYPE my_memory_free_kb gauge
my_memory_free_kb $MEM_FREE

# HELP my_disk_total_kb Total disk size in KB
# TYPE my_disk_total_kb gauge
my_disk_total_kb $DISK_TOTAL

# HELP my_disk_free_kb Free disk space in KB
# TYPE my_disk_free_kb gauge
my_disk_free_kb $DISK_FREE
EOF

    sleep 3
done

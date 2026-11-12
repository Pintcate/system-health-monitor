#!/bin/bash

# =======================================
# Project: syswatch.sh
# ========================================

# Log file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/logs/system-health.log"

# Create logs directory
mkdir -p "$SCRIPT_DIR/logs"

# Get current date and time
DATE=$(date '+%a %b %d %Y %H:%M:%S')

# Alert threshold
THRESHOLD=80

# Overall system status
OVERALL_STATUS="NORMAL"


# ========================================
# CPU MONITORING
# ========================================

CPU_USAGE=$(top -bn1 | grep "%Cpu" | awk '{print 100 - $8}')
CPU_USAGE=$(printf "%.1f" "$CPU_USAGE")

if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) ))
then
    CPU_STATUS="ALERT - High CPU Usage!"
    OVERALL_STATUS="ALERT"
else
    CPU_STATUS="NORMAL"
fi


# ========================================
# RAM MONITORING
# ========================================

RAM_USAGE=$(free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')

if (( $(echo "$RAM_USAGE > $THRESHOLD" | bc -l) ))
then
    RAM_STATUS="ALERT - High RAM Usage!"
    OVERALL_STATUS="ALERT"
else
    RAM_STATUS="NORMAL"
fi


# ========================================
# DISK MONITORING
# =======================================
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]
then
    DISK_STATUS="ALERT - High Disk Usage!"
    OVERALL_STATUS="ALERT"
else
    DISK_STATUS="NORMAL"
fi



# ========================================
# TELEGRAM ALERT SYSTEM
# ========================================

# File used to remember the previous alert state
ALERT_STATE_FILE="$SCRIPT_DIR/logs/alert-state"

# Load Telegram configuration
if [ -f "$SCRIPT_DIR/alerts/telegram.conf" ]; then

    source "$SCRIPT_DIR/alerts/telegram.conf"

    # Read the previous monitoring state
    PREVIOUS_STATE=$(cat "$ALERT_STATE_FILE" 2>/dev/null)

    # Check whether the system has an alert
    if [ "$OVERALL_STATUS" = "ALERT" ]; then

        # Send notification only for a new alert
        if [ "$PREVIOUS_STATE" != "ALERT" ]; then

            ALERT_MESSAGE="🚨 SYSTEM HEALTH ALERT

Date: $DATE

CPU Usage: $CPU_USAGE%
CPU Status: $CPU_STATUS

RAM Usage: $RAM_USAGE%
RAM Status: $RAM_STATUS

Disk Usage: $DISK_USAGE%
Disk Status: $DISK_STATUS

Overall Status: $OVERALL_STATUS"

            if [ -n "$BOT_TOKEN" ] && [ -n "$CHAT_ID" ]; then

                TELEGRAM_RESPONSE=$(curl -sS \
                    --connect-timeout 10 \
                    --max-time 20 \
                    -X POST \
                    "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
                    --data-urlencode "chat_id=${CHAT_ID}" \
                    --data-urlencode "text=${ALERT_MESSAGE}")

                if [[ "$TELEGRAM_RESPONSE" == *'"ok":true'* ]]; then
                    echo "Telegram alert sent successfully."

                    # Record that an alert has been sent
                    echo "ALERT" > "$ALERT_STATE_FILE"
                else
                    echo "WARNING: Telegram alert failed."
                    echo "$TELEGRAM_RESPONSE"
                fi

            else
                echo "WARNING: Telegram credentials are missing."
            fi

        else
            echo "System is still in ALERT state. Duplicate notification suppressed."
        fi

    else

        # Reset alert state when the system becomes normal
        if [ "$PREVIOUS_STATE" = "ALERT" ]; then
            echo "NORMAL" > "$ALERT_STATE_FILE"
            echo "System recovered. Alert state reset."
        fi

    fi

fi

# ========================================
# DISPLAY RESULTS
# ========================================

echo "========================================"
echo "SYSTEM HEALTH MONITOR"
echo "========================================"
echo "Date: $DATE"
echo
echo "CPU Usage: $CPU_USAGE%"
echo "CPU Status: $CPU_STATUS"
echo
echo "RAM Usage: $RAM_USAGE%"
echo "RAM Status: $RAM_STATUS"
echo
echo "Disk Usage: $DISK_USAGE%"
echo "Disk Status: $DISK_STATUS"
echo
echo "Overall Status: $OVERALL_STATUS"
echo "========================================"


# ========================================
# SAVE RESULTS TO LOG
# ========================================


   # ========================================
# SAVE RESULTS TO LOG
# ========================================

{
    echo ""
    echo "========================================"
    echo "SYSTEM HEALTH MONITOR"
    echo "========================================"
    echo "Date: $DATE"
    echo ""
    echo "CPU Usage: $CPU_USAGE%"
    echo "CPU Status: $CPU_STATUS"
    echo ""
    echo "RAM Usage: $RAM_USAGE%"
    echo "RAM Status: $RAM_STATUS"
    echo ""
    echo "Disk Usage: $DISK_USAGE%"
    echo "Disk Status: $DISK_STATUS"
    echo ""
    echo "Overall Status: $OVERALL_STATUS"
    echo "========================================"
    echo ""
} >> "$LOG_FILE"


# ========================================
# SAVE RESULTS TO LOG
# ========================================

{
    echo ""
    echo "========================================"
    echo "SYSTEM HEALTH MONITOR"
    echo "========================================"
    echo "Date: $DATE"
    echo ""
    echo "CPU Usage: $CPU_USAGE%"
    echo "CPU Status: $CPU_STATUS"
    echo ""
    echo "RAM Usage: $RAM_USAGE%"
    echo "RAM Status: $RAM_STATUS"
    echo ""
    echo "Disk Usage: $DISK_USAGE%"
    echo "Disk Status: $DISK_STATUS"
    echo ""
    echo "Overall Status: $OVERALL_STATUS"
    echo "========================================"
    echo ""
} >> "$LOG_FILE"

# System Health Monitor – syswatch.sh

## Project Overview

System Health Monitor is a Linux Bash automation tool designed to monitor CPU, RAM and disk usage, detect resource utilization above a configurable threshold, record system health information and send Telegram notifications when alerts occur.

## Features

- CPU usage monitoring using `top`.
- RAM usage monitoring using `free`.
- Disk usage monitoring using `df`.
- Configurable alert threshold (default: 80%).
- Automatic logging of system health information.
- Telegram notifications for high resource utilization.
- Hourly execution using Cron.
- Alert-state management to reduce duplicate notifications.

## Technologies and Tools

- Linux / Ubuntu
- Bash scripting
- top
- free
- df
- awk
- bc
- curl
- Telegram Bot API
- Cron

## Project Structure

```text
system-monitor/
├── alerts/
│   └── telegram.conf
├── logs/
│   ├── system-health.log
│   └── alert-state
├── syswatch.sh
└── README.md
```

## Installation and Usage

1. Clone or download the project.
2. Configure the Telegram bot credentials in `alerts/telegram.conf`.
3. Make the script executable:

   `chmod +x syswatch.sh`

4. Run the monitor:

   `./syswatch.sh`

5. Configure Cron for hourly execution.

## Alert Configuration

The default resource utilization threshold is 80%.

When CPU, RAM or disk usage exceeds this threshold, the script generates an alert and sends a Telegram notification.

## Automation

Cron executes the monitoring script every hour.

```cron
0 * * * * /path/to/system-monitor/syswatch.sh
```

## Security

Telegram credentials are stored in a private configuration file. The credentials and monitoring logs should not be committed to a public repository.

## Learning Outcomes

This project demonstrates practical Linux administration, Bash automation, resource monitoring, log management, scheduled tasks, API integration and basic alert management.

## Future Improvements

- Email notifications.
- Alert recovery notifications.
- Configurable monitoring intervals.
- Historical resource usage analysis.
- Disk usage investigation and reporting.

## Author

DevOps / Linux Administration Portfolio Project


# System Monitor

`syswatch.sh` reports CPU, memory, and root-filesystem usage, displays the
results in the terminal, and appends each report to `logs/system-health.log`.

## Run

```bash
./syswatch.sh
```

The script uses `top`, `free`, `df`, `awk`, and `bc`. The `alerts/` directory
is reserved for alert-related files; the current script reports alerts in its
output and log.

#!/bin/bash

VERSION="v0.1.0"
COMMAND_NAME="sysopctl"

# Display the manual page
function show_manual() {
    echo "NAME"
    echo "    $COMMAND_NAME - A custom command for managing system services, processes, and system health."
    echo
    echo "SYNOPSIS"
    echo "    $COMMAND_NAME [COMMAND] [OPTIONS]"
    echo
    echo "COMMANDS"
    echo "    service list              List all active services."
    echo "    service start <name>     Start a specified service."
    echo "    service stop <name>      Stop a specified service."
    echo "    system load              Show system load averages."
    echo "    disk usage               Display disk usage statistics."
    echo "    process monitor          Monitor real-time process activity."
    echo "    logs analyze             Summarize recent critical log entries."
    echo "    backup <path>            Backup specified files or directories."
    echo
    echo "OPTIONS"
    echo "    --help                  Display this help message."
    echo "    --version               Show version information."
}

# Handle --help and --version
if [[ "$1" == "--help" ]]; then
    show_manual
    exit 0
elif [[ "$1" == "--version" ]]; then
    echo "$COMMAND_NAME $VERSION"
    exit 0
fi

# Service management
function list_services() {
    systemctl list-units --type=service
}

function start_service() {
    systemctl start "$1" && echo "Service '$1' started successfully."
}

function stop_service() {
    systemctl stop "$1" && echo "Service '$1' stopped successfully."
}

# System load
function show_system_load() {
    uptime
}

# Disk usage
function check_disk_usage() {
    df -h
}

# Monitor processes
function monitor_processes() {
    top
}

# Analyze logs
function analyze_logs() {
    journalctl -p crit --since "24 hours ago"
}

# Backup files
function backup_files() {
    local path="$1"
    local backup_dir="/backup"
    mkdir -p "$backup_dir"
    rsync -av "$path" "$backup_dir" && echo "Backup of '$path' completed."
}

# Command handler
case "$1" in
    service)
        case "$2" in
            list)
                list_services
                ;;
            start)
                start_service "$3"
                ;;
            stop)
                stop_service "$3"
                ;;
            *)
                echo "Invalid service command. Use 'list', 'start <name>', or 'stop <name>'."
                ;;
        esac
        ;;
    system)
        case "$2" in
            load)
                show_system_load
                ;;
            *)
                echo "Invalid system command. Use 'load'."
                ;;
        esac
        ;;
    disk)
        case "$2" in
            usage)
                check_disk_usage
                ;;
            *)
                echo "Invalid disk command. Use 'usage'."
                ;;
        esac
        ;;
    process)
        case "$2" in
            monitor)
                monitor_processes
                ;;
            *)
                echo "Invalid process command. Use 'monitor'."
                ;;
        esac
        ;;
    logs)
        case "$2" in
            analyze)
                analyze_logs
                ;;
            *)
                echo "Invalid logs command. Use 'analyze'."
                ;;
        esac
        ;;
    backup)
        backup_files "$2"
        ;;
    *)
        echo "Invalid command. Use --help to see available commands."
        ;;
esac

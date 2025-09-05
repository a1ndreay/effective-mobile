#!/bin/bash

logFile="/var/log/monitoring.log"
stateFile="/var/run/test_monitoring.pid"
processName="test"
url="https://test.com/monitoring/test/api"

getPid() {
    pgrep -x "$processName"
}

logMessage() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$logFile"
}

checkProcess() {
    pid=$(getPid)
    echo "$pid"
}

checkRestart() {
    currentPid=$(getPid)
    if [ -z "$currentPid" ]; then
        return 1
    fi
    if [ -f "$stateFile" ]; then
        lastPid=$(cat "$stateFile")
        if [ "$currentPid" != "$lastPid" ]; then
            logMessage "Process $processName restarted, new pid: $currentPid"
        fi
    fi
    echo "$currentPid" > "$stateFile"
    return 0
}

sendRequest() {
    curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"
    if [ $? -ne 0 ]; then
        logMessage "Endpoint $url is unavailable"
    fi
}

main() {
    pid=$(checkProcess)
    if [ -n "$pid" ]; then
        checkRestart
        sendRequest
    fi
}

main

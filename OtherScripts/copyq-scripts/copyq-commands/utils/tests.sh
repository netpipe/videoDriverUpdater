#!/bin/bash
# Executes tests for commands (*/test_*.js).
set -euo pipefail

export COPYQ_SESSION=command-tests
export COPYQ_SESSION_COLOR=red
export COPYQ_SETTINGS_PATH=/tmp/copyq-command-tests-config
export COPYQ_LOG_FILE=/tmp/copyq-command-tests-last.log
export COPYQ_LOG_LEVEL=DEBUG
export COPYQ=${COPYQ:-copyq}

tests_log_file=/tmp/copyq-command-tests.log
copyq_pid=""
failed_count=0

run_copyq() {
    echo "--- Test Command: $COPYQ $*" >> "$COPYQ_LOG_FILE"
    "$COPYQ" "$@" 2> /dev/null
}

stop_server() {
    if [[ -n "$copyq_pid" ]]; then
        if kill "$copyq_pid"; then
            wait "$copyq_pid"
        fi
        copyq_pid=""
    fi
    rm -rf "$COPYQ_SETTINGS_PATH"
}

start_server() {
    mkdir -p "$COPYQ_SETTINGS_PATH"
    "$COPYQ" 2> /dev/null &
    copyq_pid=$!
}

init_server() {
    run_copyq show
    run_copyq copy '' > /dev/null
}

run_script() {
    run_copyq source tests/test_functions.js test.importCommandsForTest "$js"
    if ! run_copyq source tests/test_functions.js test.run "$js"; then
        cat "$COPYQ_LOG_FILE"
        echo "Failed! See whole log: $tests_log_file"
        echo
        failed_count=$((failed_count + 1))
    fi
}

trap stop_server QUIT TERM INT HUP EXIT

if [[ $# == 0 ]]; then
    exec "$0" tests/*/*.js
fi

rm -f "$tests_log_file"

for js in "$@"; do
    echo "Test: $js"

    rm -f "$COPYQ_LOG_FILE"
    echo "*** Starting: $js" >> "$tests_log_file"

    stop_server
    start_server
    init_server

    run_script "$js"

    cat "$COPYQ_LOG_FILE" > "$tests_log_file"
    echo "*** Finished: $js" >> "$tests_log_file"
done

if [[ $failed_count -gt 0 ]]; then
    echo
    echo "$failed_count test(s) failed"
    exit 1
else
    echo "All OK"
fi

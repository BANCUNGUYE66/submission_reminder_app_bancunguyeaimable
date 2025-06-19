#!/bin/bash

load_students() {
    SUBMISSIONS_FILE="${SCRIPT_DIR}/../assets/submissions.txt"
    if [ ! -f "$SUBMISSIONS_FILE" ]; then
        echo "Error: submissions.txt not found at $SUBMISSIONS_FILE"
        exit 1
    fi
    mapfile -t students < "$SUBMISSIONS_FILE"
}

check_unsubmitted() {
    echo -e "\nChecking submissions for: $ASSIGNMENT (Due: $DEADLINE)\n"
    for student in "${students[@]}"; do
        IFS=',' read -r name id status <<< "$student"
        if [ "$status" == "unsubmitted" ]; then
            echo "REMINDER: $name (ID: $id) has not submitted $ASSIGNMENT"
        fi
    done
}

#!/bin/bash

# Get absolute path to script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source dependencies using absolute paths
source "${SCRIPT_DIR}/../config/config.env"
source "${SCRIPT_DIR}/../modules/functions.sh"

# Load and check students
load_students
check_unsubmitted

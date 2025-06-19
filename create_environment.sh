#!/bin/bash

# Prompt user for name
read -p "Enter your name: " username
main_dir="submission_reminder_${username}"

# Create directory structure
mkdir -p "$main_dir"/{app,modules,assets,config}

# Create COMPLETE reminder.sh
cat > "$main_dir/app/reminder.sh" << 'EOL'
#!/bin/bash

# Get absolute path to script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source dependencies using absolute paths
source "${SCRIPT_DIR}/../config/config.env"
source "${SCRIPT_DIR}/../modules/functions.sh"

# Load and check students
load_students
check_unsubmitted
EOL

# Create COMPLETE functions.sh
cat > "$main_dir/modules/functions.sh" << 'EOL'
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
EOL

# Create config.env
cat > "$main_dir/config/config.env" << 'EOL'
ASSIGNMENT="Initial Assignment"
DEADLINE="2025-07-01"
EOL

# Create submissions.txt
cat > "$main_dir/assets/submissions.txt" << 'EOL'
John Doe,1001,submitted
Jane Smith,1002,unsubmitted
Alex Johnson,1003,unsubmitted
Sarah Williams,1004,submitted
Mike Brown,1005,unsubmitted
EOL

# Create startup.sh
cat > "$main_dir/startup.sh" << 'EOL'
#!/bin/bash
echo "Starting submission reminder system..."
cd "$(dirname "$0")"
./app/reminder.sh
EOL

# Set permissions
chmod +x "$main_dir"/app/reminder.sh
chmod +x "$main_dir"/modules/functions.sh
chmod +x "$main_dir"/startup.sh

echo -e "\nSetup complete in: $main_dir"
echo "Run the app with: ./$main_dir/startup.sh"

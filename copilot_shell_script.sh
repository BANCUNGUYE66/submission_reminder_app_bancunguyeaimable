#!/bin/bash

# Debug: Show current directory
echo "Current directory: $(pwd)"

# Find the reminder directory (looking in current directory only)
REMINDER_DIR="$(pwd)/submission_reminder_ash"

# Debug: Show directory being checked
echo "Looking for directory: $REMINDER_DIR"

if [ ! -d "$REMINDER_DIR" ]; then
    echo "Error: Directory not found"
    echo "Expected path: $REMINDER_DIR"
    echo "Existing submission_reminder directories:"
    ls -d submission_reminder_* 2>/dev/null || echo "None found"
    exit 1
fi

CONFIG_FILE="$REMINDER_DIR/config/config.env"

# Debug: Show config file path
echo "Looking for config file: $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.env not found"
    echo "Contents of config directory:"
    ls -l "$REMINDER_DIR/config/" || echo "Config directory not found"
    exit 1
fi

# Get new assignment
read -p "Enter new assignment name: " assignment_name

# Update config
sed -i '' "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$assignment_name\"/" "$CONFIG_FILE"

echo "Updated assignment to: $assignment_name"
echo "Running check..."

# Run from the correct directory
(cd "$REMINDER_DIR" && ./startup.sh)

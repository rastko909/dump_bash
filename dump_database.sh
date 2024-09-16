#!/bin/bash

# Prompt the user to select a custom .env file or use the default
read -p "Enter the path to the .env file (press Enter to use the default '.env'): " env_file

# Set the default .env file if the user does not provide a custom file
env_file="${env_file:-.env}"

# Load environment variables from the specified .env file if it exists
if [ -f "$env_file" ]; then
    export $(egrep -v '^#' "$env_file" | xargs)
else
    echo "Environment file '$env_file' not found. Please check the file path."
    exit 1
fi

# Navigate to the script directory
cd "$(dirname "$0")"

# Ensure the dumps directory exists
BACKUP_DIR="./dumps"
mkdir -p "$BACKUP_DIR"

# Format the current date and make it lowercase for the filename
CURRENT_DATE=$(date +"%b_%d_%Y" | tr '[:upper:]' '[:lower:]')

# Define the backup filename
BACKUP_FILENAME="dispensed_${CURRENT_DATE}.sql"

# Use environment variables for PostgreSQL credentials
POSTGRES_HOST=${POSTGRES_HOST}
POSTGRES_DB=${POSTGRES_DB}
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_PORT=${POSTGRES_PORT}

# Export the password to avoid prompting
export PGPASSWORD="${POSTGRES_PASSWORD}"

# Display a simple progress message
echo "Starting backup of the ${POSTGRES_DB} database..."
echo "Please wait..."

# Perform the database backup in plain text format
pg_dump -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" > "${BACKUP_DIR}/${BACKUP_FILENAME}"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successfully completed: ${BACKUP_DIR}/${BACKUP_FILENAME}"
else
    echo "Backup failed."
fi

# Clean up the environment variable
unset PGPASSWORD

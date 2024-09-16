#!/bin/bash

# Display a list of available SQL dump files in the dumps directory
echo "Available SQL dump files:"
select dump_file in ./dumps/*.sql; do
    if [[ -n $dump_file ]]; then
        echo "Selected dump file: $dump_file"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Run docker ps to show running containers
echo "Running containers:"
docker ps

# Ask for Docker container name
read -p "Enter the Docker Postgres container name: " docker_container

# Ask if the user wants to create a new database
read -p "Do you want to create a new database? (y/n): " create_db_choice

if [[ "$create_db_choice" == "y" || "$create_db_choice" == "Y" ]]; then
    # Ask for the new database name
    read -p "Enter the new database name: " new_db_name

    # Create the new database
    echo "Creating new database '$new_db_name'..."
    docker exec -i "$docker_container" psql -U postgres -c "CREATE DATABASE \"$new_db_name\";"

    # Use the new database for the restore
    local_db="$new_db_name"
else
    # Ask for the existing local database name
    read -p "Enter the local database name: " local_db
fi

# Run the SQL script
echo "Executing SQL script..."
cat "$dump_file" | docker exec -i "$docker_container" psql -U postgres -d "$local_db"

echo "Script execution completed."

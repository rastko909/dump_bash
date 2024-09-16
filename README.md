# Database Dump and Restore Scripts

This repository contains two Bash scripts to help manage database dumps and restore them to local Docker PostgreSQL containers.

## Scripts

1. **`dump_database.sh`**  
   This script creates a dump of the PostgreSQL database using environment variables specified in a `.env` file. The dump is saved in the `./dumps` directory with a timestamped filename. The script also allows you to specify a custom `.env` file.

2. **`cat.sh`**  
   This script allows you to select a database dump file and restore it to a PostgreSQL container running in Docker. The user is prompted to select the desired SQL dump file, Docker container name, and local database name. It also provides the option to create a new database before restoring.

## Usage

### Prerequisites

- Ensure that you have Docker installed and running.
- The PostgreSQL container should be running and accessible.
- Create a `.env` file in the same directory as the scripts with the necessary environment variables:

```bash
POSTGRES_HOST=your_postgres_host
POSTGRES_DB=your_database_name
POSTGRES_USER=your_username
POSTGRES_PASSWORD=your_password
POSTGRES_PORT=your_port
```

### Running the Scripts

1. **Dump the Database**

   Run the `dump_database.sh` script to create a backup of the PostgreSQL database:

   ```bash
   ./dump_database.sh
   ```

   The script will:

   - Prompt the user to select a custom `.env` file or use the default `.env`.
   - Load environment variables from the specified `.env` file.
   - Navigate to the script directory and create a `dumps` folder if it doesn’t exist.
   - Format the current date for the backup filename.
   - Perform the database backup and store it in the `./dumps` directory.

2. **Restore the Database to a Docker Container**

   Run the `cat.sh` script to restore a database dump into a Docker container:

   ```bash
   ./cat.sh
   ```

   The script will:

   - Display a list of available SQL dump files and allow the user to select one.
   - Show running Docker containers and prompt the user to enter the name of the Docker PostgreSQL container.
   - Ask if the user wants to create a new database. If so, prompt for the new database name and create it.
   - Prompt the user for the local database name where the dump should be restored.
   - Execute the SQL script inside the specified Docker container.

### Example Workflow

1. **Dump the Database:**

   ```bash
   ./dump_database.sh
   ```

   Example Output:

   ```bash
   Enter the path to the .env file (press Enter to use the default '.env'):
   Starting backup of the dispensed database...
   Please wait...
   Backup successfully completed: ./dumps/dispensed_aug_13_2024.sql
   ```

2. **Restore the Database:**

   ```bash
   ./cat.sh
   ```

   Example Output:

   ```bash
   Available SQL dump files:
   1) ./dumps/dispensed_aug_13_2024.sql
   2) ./dumps/dispensed_sep_16_2024.sql
   Enter the number corresponding to your choice: 1
   Running containers:
   CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS         PORTS                     NAMES
   2b5f32d7d4e1   postgres:13     "docker-entrypoint.s…"   2 hours ago     Up 2 hours     0.0.0.0:5432->5432/tcp    my_postgres_container
   Enter the Docker Postgres container name: my_postgres_container
   Do you want to create a new database? (y/n): y
   Enter the new database name: new_database_name
   Creating new database 'new_database_name'...
   Enter the local database name: new_database_name
   Executing SQL script...
   Script execution completed.
   ```

## Notes

- Ensure you have the necessary permissions to execute these scripts.
- The `cat.sh` script relies on the user to correctly identify the running Docker container and database name.

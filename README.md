# Salon Appointment Scheduler

This project is part of the freeCodeCamp certification. It is an interactive Bash script (`salon.sh`) that uses a PostgreSQL database to manage salon customers and appointments.

## About

- **Database**: The `salon.sql` file contains the database schema and initial data for the salon.
- **Script**: The `salon.sh` script allows you to add customers, schedule appointments, and view existing appointments interactively.

## Setup

1. Import the database:
   ```bash
   createdb salon
   psql salon < salon.sql
   ```

2. Run the script:
   ```bash
   chmod +x salon.sh
   ./salon.sh
   ```

---


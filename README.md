

# Data Engineering Project: Raw Warehouse to Staging Warehouse Upload

## Project Overview

This project is designed to facilitate the transfer of data from a raw warehouse to a staging warehouse using MySQL stored procedures. The data is uploaded incrementally based on the `created_date` field, ensuring that only new and updated records are processed. The project includes various stored procedures for daily, weekly, and monthly data uploads.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Stored Procedures](#stored-procedures)
    - [Daily Upload](#daily-upload)
    - [Monthly Upload](#monthly-upload)
    - [Weekly Upload](#weekly-upload)
    - [Final Elevation](#final-elevation)
4. [Usage](#usage)
5. [License](#license)

## Prerequisites

- MySQL installed and configured
- Access to the raw and staging warehouses
- Basic knowledge of MySQL stored procedures

## Project Structure

The project includes the following main components:

- **Daily Upload Stored Procedure:** Incrementally uploads data on a daily basis.
- **Monthly Upload Stored Procedure:** Incrementally uploads data on a monthly basis.
- **Weekly Upload:** Uses a `md_weekly` table to manage weekly data uploads.
- **Final Elevation Stored Procedure:** Uses the `md_date` table to manage the final data elevation with parameters such as `start_date`, `end_date`, `is_Nepali`, and `date_level`.

## Stored Procedures

### Daily Upload

The daily upload stored procedure processes data incrementally on a daily basis using the `created_date` field.

### Monthly Upload

The monthly upload stored procedure processes data incrementally on a monthly basis using the `created_date` field.

### Weekly Upload

The weekly upload process involves using the `md_weekly` table to handle the weekly data uploads.

### Final Elevation

The final elevation stored procedure retrieves parameters from the `md_date` table, including `start_date`, `end_date`, `is_Nepali`, and `date_level`, to evaluate and process the uploaded data.

### Partitioning
The partitioning process involves creating a new table with the same structure as the original table, but with partitions based on the date, also known as range partitions.


## Usage

1. **Daily Upload:**
   - Execute the daily upload stored procedure to process and upload data on a daily basis.
   
   ```sql
   CALL sp_sw_daily();
   ```
    - A DDL structure creates an empty table if not already existing, then values are added incrementally to the table with each call
   ```sql
   CALL sp_sw_daily_update();
   ```
   

2. **Monthly Upload:**
   - Execute the monthly upload stored procedure to process and upload data on a monthly basis.
   
   ```sql
   CALL sp__sw_monthly();
   ```

3. **Weekly Upload:**
   - Ensure the `md_weekly` table is correctly set up.
   - Execute the necessary stored procedure to manage weekly uploads.
   
   ```sql
   CALL sp_sw_weekly();
   ```

4. **Final Elevation:**
   - Ensure the `md_date` table is correctly populated with parameters.
   - Execute the final elevation stored procedure to process the final data evaluation.
   - Here firstly a DDL is defined for the table to be created
   - Then the values are appended to it
   
   ```sql
   CALL sp_sw_table();
   ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

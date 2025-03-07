# Database Audit System for Order Line and Customer Tables

This project includes SQL scripts that implement auditing mechanisms for tracking changes in database tables. The system is designed to log actions performed on the `CUSTOMER` and `ORDER_LINE` tables in an Oracle database.

## Features

- **Audit Modifications to the `CUSTOMER` Table**:
  - A table called `customer_audit` records who and when the `CUSTOMER` table is modified.
  - A sequence and trigger are used to track and log changes to the `CUSTOMER` table.

- **Track Changes in the `ORDER_LINE` Table**:
  - A trigger is created on the `ORDER_LINE` table to record actions such as `INSERT`, `UPDATE`, and `DELETE`.
  - The changes are logged in an `order_line_audit` table with information on who performed the action and when.

- **Log Updates on `ol_quantity` in the `ORDER_LINE` Table**:
  - A table called `order_line_row_audit` is created to store the **old value** of `ol_quantity` whenever it is updated in the `ORDER_LINE` table.

## Database Setup

### Prerequisites

1. Oracle Database with access to the `des02` schema (or appropriate schema for your environment).
2. Required permissions to create tables and triggers.

### SQL Scripts

1. **Question 1: Auditing Customer Table**
   - Creates the `customer_audit` table and triggers to track modifications to the `CUSTOMER` table.
   - Includes a sequence to uniquely identify each entry in the audit table.

   ```sql
   -- Create the customer_audit table
   CREATE TABLE customer_audit (
       row_num NUMBER,
       date_updated DATE,
       from_who VARCHAR2(40)
   );
   
   -- Create the trigger to track changes in the CUSTOMER table
   CREATE OR REPLACE TRIGGER customer_trigger
   AFTER INSERT OR UPDATE OR DELETE ON CUSTOMER
   FOR EACH ROW
   BEGIN
       -- Insert auditing data into customer_audit table
   END;

1. **Question 2: Auditing the `ORDER_LINE` Table**

This SQL script creates a trigger that records who, when, and the action performed on the `ORDER_LINE` table. The actions that are tracked include `INSERT`, `UPDATE`, and `DELETE`. These actions are logged in an `order_line_audit` table, which records the action performed, the user ID, and the timestamp.

### Features:
- **Tracks actions**: `INSERT`, `UPDATE`, and `DELETE` on the `ORDER_LINE` table.
- **Audit information**: The audit table stores the **action performed**, **user ID**, and **timestamp** of each change.

3. **Question 3: Auditing Changes to `ol_quantity` in the `ORDER_LINE` Table**

This SQL script is designed to track and audit updates to the `ol_quantity` field in the `ORDER_LINE` table. The trigger captures the **old value** of `ol_quantity` every time it is updated and logs this information in the `order_line_row_audit` table. This provides an audit trail for changes to `ol_quantity`, along with the `row_num` and the timestamp of the update.

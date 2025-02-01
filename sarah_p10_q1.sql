/* 

    Question 1: (use schemas des02 with script 7clearwater)
    We need to know WHO, and WHEN the table CUSTOMER is modified.
    Create table, sequence, and trigger to record the needed information.
    Test your trigger! 

*/

connect sys/sys as sysdba;
spool C:\Sarah\sem.3\databases2\assignments\10\sarah_p10_q1.txt;

connect des02/des02;

select table_name from user_tables;

-- Create a table,
CREATE TABLE customer_audit(row_num NUMBER, date_updated DATE, from_who VARCHAR2(40));

-- sequence,
CREATE SEQUENCE customer_audit_sequence;

-- trigger.
CREATE OR REPLACE TRIGGER customer_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON customer
        BEGIN
        INSERT INTO customer_audit
        VALUES(customer_audit_sequence.NEXTVAL, sysdate, user);
    END;
   /

-- Create User
connect sys/sys as sysdba;

CREATE USER sarah IDENTIFIED BY 123;

GRANT connect, resource TO sarah;

-- Connect back to des02
connect des02/des02;

GRANT SELECT, UPDATE, INSERT, DELETE ON customer TO sarah;

-- Log in as new user and update the table customer
connect sarah/123;
SELECT * FROM des02.customer;

UPDATE des02.customer SET c_state = 'MN' WHERE c_id = 1;

-- Log In as des02 to view WHO and WHEN table was altered
connect des02/des02;
SELECT row_num, TO_CHAR (date_updated, 'DD Month YYYY Day HH:MI:SS Am'), from_who
FROM customer_audit;

spool off;


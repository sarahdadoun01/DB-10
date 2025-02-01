/*

    Question 3: (use script 7clearwater)
    Create a table called order_line_row_audit to record who, when, and the OLD 
    value of ol_quantity every time the data of table ORDER_LINE is updated.
    Test your trigger!

*/

connect sys/sys as sysdba;
spool C:\Sarah\sem.3\databases2\assignments\10\sarah_p10_q3.txt;

connect des02/des02;

select table_name from user_tables;

-- Create a table,
DROP TABLE order_line_audit;
CREATE TABLE order_line_audit(row_num NUMBER, date_updated DATE, from_who VARCHAR2(40), old_ol_quantity NUMBER);

-- sequence,
DROP SEQUENCE order_line_audit_sequence;
CREATE SEQUENCE order_line_audit_sequence;

-- trigger.
CREATE OR REPLACE TRIGGER order_line_audit_trigger
    AFTER UPDATE ON order_line
    FOR EACH ROW
    BEGIN
        INSERT INTO order_line_audit
        VALUES(order_line_audit_sequence.NEXTVAL, sysdate, user, :OLD.ol_quantity);
    END;
   /

-- Connect back to des02
connect des02/des02;

GRANT SELECT, UPDATE, INSERT, DELETE ON order_line TO sarah;

-- Log in as new user and update the table customer
connect sarah/123;
SELECT * FROM des02.order_line;

UPDATE des02.order_line SET ol_quantity = 20 WHERE o_id = 2;

-- Log In as des02 to view WHO and WHEN table was altered
connect des02/des02;
SELECT row_num, TO_CHAR (date_updated, 'DD Month YYYY Day HH:MI:SS Am'), from_who, action
FROM order_line_audit;

spool off;
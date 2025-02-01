/*

    Question 2:
    Table ORDER_LINE is subject to INSERT, UPDATE, and DELETE, create a trigger to record who, 
    when, and the action performed on the table order_line in a table called order_line_audit.
    (hint: use UPDATING, INSERTING, DELETING to verify for action performed. For example: IF UPDATING THEN …)
    Test your trigger!

*/

connect sys/sys as sysdba;
spool C:\Sarah\sem.3\databases2\assignments\10\sarah_p10_q2.txt;

connect des02/des02;

select table_name from user_tables;

-- Create a table,
CREATE TABLE order_line_audit(row_num NUMBER, date_updated DATE, from_who VARCHAR2(40), action VARCHAR2(40));

-- sequence,
CREATE SEQUENCE order_line_audit_sequence;

-- trigger.
CREATE OR REPLACE TRIGGER order_line_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON order_line
    BEGIN
        IF INSERTING THEN
            INSERT INTO order_line_audit
            VALUES(order_line_audit_sequence.NEXTVAL, sysdate, user, 'INSERT');
        ELSIF UPDATING THEN
            INSERT INTO order_line_audit
            VALUES(order_line_audit_sequence.NEXTVAL, sysdate, user, 'UPDATE');
        ELSIF DELETING THEN
            INSERT INTO order_line_audit
            VALUES(order_line_audit_sequence.NEXTVAL, sysdate, user, 'DELETE');
        END IF;
    END;
   /

-- Connect back to des02
connect des02/des02;

GRANT SELECT, UPDATE, INSERT, DELETE ON order_line TO sarah;

-- Log in as new user and update the table customer
connect sarah/123;
SELECT * FROM des02.order_line;

UPDATE des02.order_line SET ol_quantity = 10 WHERE o_id = 1;

-- Log In as des02 to view WHO and WHEN table was altered
connect des02/des02;
SELECT row_num, TO_CHAR (date_updated, 'DD Month YYYY Day HH:MI:SS Am'), from_who, action
FROM order_line_audit;

spool off;


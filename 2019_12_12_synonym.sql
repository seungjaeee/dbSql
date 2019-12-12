SELECT *
FROM SJSJ.uesrs;

SELECT *
FROM jobs;

SELECT *
FROM user_tables;

SELECT *
FROM all_tables
WHERE OWNER = 'SJSJ';

SELECT *
FROM SJSJ.fastfood;

SELECT *
FROM DBA_DATA_FILES;

SELECT *
FROM DBA_USERS;

--SJSJ.fastfood --> fastfood
CREATE SYNONYM fastfood FOR SJSJ.fastfood;

SELECT *
FROM fastfood;

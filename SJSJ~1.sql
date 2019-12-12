CREATE TABLE employees(
            EMPLOYEE_ID NUMBER(6) PRIMARY KEY,
            FIRST_NAME VARCHAR2(20) ,
            LAST_NAME VARCHAR2(25) ,
            EMAIL VARCHAR2(25),
            PHONE_NUMBER VARCHAR2(20),
            HIRE_DATE DATE,
            JOB_ID VARCHAR2(10),
            SALARY NUMBER(8, 2),
            COMMISSION_PCT NUMBER(2, 2),
            MANAGER_ID NUMBER(6),
            CONSTRAINT FK_employees01 FOREIGN KEY(MANAGER_ID)
            REFERENCES employees(EMPLOYEE_ID),
            CONSTRAINT FK_employees02 FOREIGN KEY(JOB_ID)
            REFERENCES jobs(JOB_ID),
            CONSTRAINT FK_employees03 FOREIGN KEY(DEPARTMENT_ID)
            REFERENCES departments(DEPARTMENT_ID),
            CONSTRAINT NN_employees01 CHECK(FIRST_NAME IS NOT NULL),
            CONSTRAINT NN_employees02 CHECK(LAST_NAME IS NOT NULL)
            );
            
CREATE TABLE jobs (
            JOB_ID VARCHAR2(10)PRIMARY KEY,
            JOB_TITLE VARCHAR2(35),
            MIN_SALARY NUMBER(6),
            MAX_SALARY NUMBER(6));
         
           
            
CREATE TABLE job_history(
            EMPLOYEE_ID NUMBER(6),
            START_DATE DATE ,
            END_DATE DATE ,
            JOB_ID VARCHAR2(10) ,
            DEPARTMENT_ID NUMBER(4),
            CONSTRAINT FK_job_history01 FOREIGN KEY(JOB_ID)
            REFERENCES jobs(JOB_ID),
            CONSTRAINT FK_job_history02 FOREIGN KEY(DEPARTMENT_ID)
            REFERENCES departments(DEPARTMENT_ID),            
            CONSTRAINT PK_job_history PRIMARY KEY(EMPLOYEE_ID, START_DATE),
            CONSTRAINT NN_job_history CHECK(END_DATE IS NOT NULL),
            CONSTRAINT NN_job_history02 CHECK(JOB_ID IS NOT NULL));
CREATE TABLE regions (
            REGION_ID NUMBER ,
            REGION_NAME VARCHAR2(25),
            CONSTRAINT PK_regiongs PRIMARY KEY(REGION_ID),
            CONSTRAINT NN_regions CHECK(REGION_NAME IS NOT NULL)
            );
 
           
            
CREATE TABLE countries (
            COUNTRY_ID CHAR(2),
            COUNTRY_NAME VARCHAR2(40),
            REGION_ID NUMBER,            
            CONSTRAINT PK_countries PRIMARY KEY(COUNTRY_ID),
            CONSTRAINT FK_countries FOREIGN KEY(REGION_ID)
            REFERENCES regions(REGION_ID));

CREATE TABLE locations (
            LOCATION_ID NUMBER(4),
            STREET_ADDRESS VARCHAR2(40),
            POSTAL_CODE VARCHAR2(12) ,
            CITY VARCHAR2(30),
            STATE_PROVINCE VARCHAR2(25),
            COUNTRY_ID CHAR(2),
            CONSTRAINT FK_locations FOREIGN KEY(COUNTRY_ID)
            REFERENCES countries(COUNTRY_ID),
            CONSTRAINT PK_locations PRIMARY KEY(LOCATION_ID),
            CONSTRAINT NN_locations CHECK(CITY IS NOT NULL));
            
CREATE TABLE departments (
            DEPARTMENT_ID NUMBER(4),
            DEPARTMENT_NAME VARCHAR2(30),
            MANAGER_ID NUMBER(6),
            LOCATION_ID NUMBER(4),
            CONSTRAINT FK_departments01 FOREIGN KEY(LOCATION_ID)
            REFERENCES locations(LOCATION_ID),            
            CONSTRAINT PK_departments PRIMARY KEY(DEPARTMENT_ID),
            CONSTRAINT NN_departments CHECK(DEPARTMENT_NAME IS NOT NULL));
            
ALTER TABLE departments ADD CONSTRAINT FK_departments02 FOREIGN KEY(MANAGER_ID)
REFERENCES employees(EMPLOYEE_ID);

ALTER TABLE job_history ADD CONSTRAINT FK_job_history02 FOREIGN KEY(EMPLOYEE_ID)
REFERENCES employees(EMPLOYEE_ID);
            
            
            
            
            
            
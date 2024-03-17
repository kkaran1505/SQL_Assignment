Create database Case_Study2

use Case_Study2

CREATE TABLE LOCATION (
  Location_ID INT PRIMARY KEY,
  City VARCHAR(50)
);

INSERT INTO LOCATION (Location_ID, City)
VALUES (122, 'New York'),
       (123, 'Dallas'),
       (124, 'Chicago'),
       (167, 'Boston');


  CREATE TABLE DEPARTMENT (
  Department_Id INT PRIMARY KEY,
  Name VARCHAR(50),
  Location_Id INT,
  FOREIGN KEY (Location_Id) REFERENCES LOCATION(Location_ID)
);


INSERT INTO DEPARTMENT (Department_Id, Name, Location_Id)
VALUES (10, 'Accounting', 122),
       (20, 'Sales', 124),
       (30, 'Research', 123),
       (40, 'Operations', 167);

	   CREATE TABLE JOB (
  Job_ID INT PRIMARY KEY,
  Designation VARCHAR(50)
);

CREATE TABLE JOB
(JOB_ID INT PRIMARY KEY,
DESIGNATION VARCHAR(20))

INSERT  INTO JOB VALUES
(667, 'CLERK'),
(668,'STAFF'),
(669,'ANALYST'),
(670,'SALES_PERSON'),
(671,'MANAGER'),
(672, 'PRESIDENT')


CREATE TABLE EMPLOYEE
(EMPLOYEE_ID INT,
LAST_NAME VARCHAR(20),
FIRST_NAME VARCHAR(20),
MIDDLE_NAME CHAR(1),
JOB_ID INT FOREIGN KEY
REFERENCES JOB(JOB_ID),
MANAGER_ID INT,
HIRE_DATE DATE,
SALARY INT,
COMM INT,
DEPARTMENT_ID  INT FOREIGN KEY
REFERENCES DEPARTMENT(DEPARTMENT_ID))

INSERT INTO EMPLOYEE VALUES
(7369,'SMITH','JOHN','Q',667,7902,'17-DEC-84',800,NULL,20),
(7499,'ALLEN','KEVIN','J',670,7698,'20-FEB-84',1600,300,30),
(7505,'DOYLE','JEAN','K',671,7839,'04-APR-85',2850,NULl,30),
(7506,'DENNIS','LYNN','S',671,7839,'15-MAY-85',2750,NULL,30),
(7507,'BAKER','LESLIE','D',671,7839,'10-JUN-85',2200,NULL,40),
(7521,'WARK','CYNTHIA','D',670,7698,'22-FEB-85',1250,500,30)

select * from department
select  * from employee
select  * from job
select  * from location

--10. Find out the employees who earn greater than the average salary for their department.

select * from EMPLOYEE E
where E.SALARY > (select avg(Salary) from employee where DEPARTMENT_ID=E.DEPARTMENT_ID) and E.DEPARTMENT_ID in (10,20,30,40)

--9. Find out which department has no employees.

select name from DEPARTMENT
where Department_Id=(
select Department_Id from DEPARTMENT
except
select Department_Id from EMPLOYEE)

--8. List out the employees who earn more than every employee in department 30.

Select * from EMPLOYEE
where SALARY > ( select min(salary) from EMPLOYEE where DEPARTMENT_ID=30)

--7. Display the second highest salary drawing employee details.
SELECT * FROM employee
WHERE salary = (SELECT MAX(salary)
    FROM employee
    WHERE salary < (SELECT MAX(salary)
        FROM employee))

--6. Update the salaries of employees who are working as clerks on the basis of 10%.

update EMPLOYEE
set SALARY=SALARY*1.10
where JOB_ID=(select JOB_ID from job where Designation='clerk')

select * from EMPLOYEE

--5. Find out the number of employees working in the sales department.

select count(employee_id) as No_of_Employee from EMPLOYEE
where DEPARTMENT_ID=(select DEPARTMENT_ID from DEPARTMENT where Name='sales')

--4. Display the list of employees who are living in 'Boston'.

select * from EMPLOYEE
where DEPARTMENT_ID=
(select department_id from DEPARTMENT 
where Location_id=
(select location_id from LOCATION
where city='Boston'))

--3. Display the employees who are working as 'Clerk'.
select * from EMPLOYEE
where JOB_ID=
(
select job_id from job
where Designation='clerk'
)

--2. Display the employees who are working in the sales department.

select * from EMPLOYEE
where DEPARTMENT_ID=
(
select Department_id from DEPARTMENT
where name='Sales'
)

--1. Display the employees list who got the maximum salary.

select * from EMPLOYEE
where SALARY=
(
select max(salary) from EMPLOYEE
)

--1. Display the employee details with salary grades. 
--Use conditional statement to create a grade column.

SELECT 
    employee_id, 
    first_name, 
    last_name, 
    salary,
    CASE
        WHEN salary >= 2000 THEN 'A'
        WHEN salary >= 1000 AND salary < 2000 THEN 'B'
        WHEN salary >= 800 AND salary < 1000 THEN 'C'
        ELSE 'D'
    END AS grade
FROM employee;

--2. List out the number of employees grade wise. 
--Use conditional statement to create a grade column.

SELECT 
    grade,
    COUNT(*) AS num_employees
FROM (
    SELECT 
        employee_id,
        first_name,
        last_name,
        CASE
			WHEN salary >= 2000 THEN 'A'
			WHEN salary >= 1000 AND salary < 2000 THEN 'B'
			WHEN salary >= 800 AND salary < 1000 THEN 'C'
			ELSE 'D'
        END AS grade
    FROM employee
) AS graded_employees
GROUP BY grade;

--3. Display the employee salary grades and the number of employees 
--between 2000 to 5000 range of salary.


SELECT 
    grade,
    COUNT(*) AS num_employees
FROM (
    SELECT 
        employee_id,
        first_name,
        last_name,
        CASE
			WHEN salary >= 2000 THEN 'A'
			WHEN salary >= 1000 AND salary < 2000 THEN 'B'
			WHEN salary >= 800 AND salary < 1000 THEN 'C'
			ELSE 'D'
        END AS grade
    FROM employee
    WHERE salary >= 2000 AND salary <= 5000
) AS graded_employees
GROUP BY grade;
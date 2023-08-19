** PROJECT NO. 04  (Portfolio Project for Data Analysts Human Resource)hr.csv file
                       ------------------------------------------------------------------------------

create database hr;
use hr;
select * from humanresource;
ALTER TABLE humanresource
RENAME TO hr1;
select * from hr1;
describe hr1;
select birthdate FROM hr1;
SET sql_safe_updates=0;

UPDATE hr1 SET birthdate=CASE 
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
ELSE null
end;
select * from hr1;
SELECT * FROM hr1 LIMIT 5;
 ALTER TABLE hr1 MODIFY COLUMN birthdate DATE;
 describe hr1;
*/ Convert hire_date values to date /*

UPDATE hr1
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d')
  ELSE NULL
END;



*/ Change hire_date column data type /*

ALTER TABLE hr1 MODIFY COLUMN hire_date DATE;
SELECT termdate FROM hr1 LIMIT 10;

*/ Add age column/*


ALTER TABLE hr1 ADD COLUMN age INT;

UPDATE hr1 SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());


SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr1;

SELECT COUNT(*) FROM hr1 WHERE age >18;

*/ Check Termdates in the future /*

SELECT COUNT(*)
FROM hr1
WHERE termdate > CURDATE();

SELECT COUNT(*)
FROM hr1
WHERE termdate = '0000-00-00';


/*Questions
1.What is the gender breakdown of employees in the company?
2.What is the race/ethnicity breakdown of employees in the company?
3.What is the age distribution of employees in the company?
4.How many employees work at headquarters versus remote locations?
5.What is the average length of employment for employees who have been terminated?
6.How does the gender distribution vary across departments and job titles?
7.What is the distribution of job titles across the company?
8.Which department has the highest turnover rate?
9.What is the distribution of employees across locations by city and state?
10.How has the company's employee count changed over time based on hire and term dates?*/

 SHOW COLUMNS FROM hr1;
 
* /1. What is the gender breakdown of employees in the company? /*
 
SELECT gender, COUNT(*) AS count
FROM hr1
WHERE age >= 18
GROUP BY gender;

*/ 2. What is the race/ethnicity breakdown of employees in the company? /*

SELECT race, COUNT(*) AS count
FROM hr1
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;

*/ 3. What is the age distribution of employees in the company? /*

SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr1
WHERE age >= 18;

SELECT FLOOR(age/10)10 AS age_group, COUNT() AS count
FROM hr1
WHERE age >= 18
GROUP BY FLOOR(age/10)*10;


SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(*) AS count
FROM 
  hr1
WHERE 
  age >= 18
GROUP BY age_group
ORDER BY age_group;

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(*) AS count
FROM 
  hr1
WHERE 
  age >= 18
GROUP BY age_group, gender
ORDER BY age_group, gender;

*/ 4. How many employees work at headquarters versus remote locations? /*

SELECT location, COUNT(*) as count
FROM hr1
WHERE age >= 18
GROUP BY location;

*/ 5. What is the average length of employment for employees who have been terminated? /*

SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr1
WHERE termdate <> '0000-00-00' AND termdate <= CURDATE() AND age >= 18;

SELECT ROUND(AVG(DATEDIFF(termdate, hire_date)),0)/365 AS avg_length_of_employment
FROM hr1
WHERE termdate <= CURDATE() AND age >= 18;

*/ 6. How does the gender distribution vary across departments? /*
 
SELECT department, gender, COUNT(*) as count
FROM hr1
WHERE age >= 18
GROUP BY department, gender
ORDER BY department;

*/ 7. What is the distribution of job titles across the company? /*

SELECT jobtitle, COUNT(*) as count
FROM hr1
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;

*/ 8. Which department has the highest turnover rate?
"Turnover rate" typically refers to the rate at which employees leave a company or department and need to be replaced. It can be calculated as the number of employees who leave over a given time period divided by the average number of employees in the company or department over that same time period.*/

SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr1
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

/9. What is the distribution of employees across locations by state?/
SELECT location_state, COUNT(*) as count
FROM hr1
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

/*10. How has the company's employee count changed over time based on hire and term dates?
This query groups the employees by the year of their hire date and calculates the total number of hires, terminations, and net change (the difference between hires and terminations) for each year. The results are sorted by year in ascending order.*/

SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT() - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT() * 100),2) AS net_change_percent
FROM 
    hr1
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
    
    /In this modified query, a subquery is used to first calculate the terminations alias, which is then used in the calculation for the net_change and net_change_percent column in the outer query./
    SELECT 
    year, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires * 100), 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year, 
        COUNT(*) AS hires, 
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM 
        hr1
    WHERE age >= 18
    GROUP BY 
        YEAR(hire_date)
) subquery
ORDER BY 
    year ASC;
    
    /11. What is the tenure distribution for each department?/

SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr1
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;


*/ Thank You */ 


  Human Resource Project is completed. 
  
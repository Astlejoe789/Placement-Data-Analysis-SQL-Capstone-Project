CREATE TABLE placements (
    Name VARCHAR(100),
    Email VARCHAR(100),
    Course VARCHAR(50),
    Branch VARCHAR(50),
    Graduation_Year INT,
    Company VARCHAR(100),
    Job_Role VARCHAR(100),
    Salary_INR INT,
    Location VARCHAR(100),
    Placement_Date DATE
);
select * from placements

--Top 5 Companies Hiring the Most Students

SELECT Company, COUNT(*) AS num_hires
FROM placements
GROUP BY Company
ORDER BY num_hires DESC
LIMIT 5;

--Average Salary by Branch

SELECT Branch, ROUND(AVG(Salary_INR)) AS avg_salary
FROM placements
GROUP BY Branch
ORDER BY avg_salary DESC;

--Placement Rate by Graduation Year

SELECT Graduation_Year, COUNT(*) AS placements
FROM placements
GROUP BY Graduation_Year
ORDER BY Graduation_Year;

--Most Common Placement Cities

SELECT Location, COUNT(*) AS count
FROM placements
GROUP BY Location
ORDER BY count DESC
LIMIT 5;

--Popular Job Roles and Their Avg Salaries

SELECT Job_Role, COUNT(*) AS role_count, ROUND(AVG(Salary_INR)) AS avg_salary
FROM placements
GROUP BY Job_Role
ORDER BY role_count DESC
LIMIT 5;



--Branch Performance Comparison

SELECT 
    branch,
    COUNT(*) AS total_placements,
    ROUND(AVG(salary_inr)) AS avg_salary
FROM placements
GROUP BY branch
ORDER BY total_placements DESC, avg_salary DESC;

--Top 3 Job Roles Per Course

SELECT course, job_role, role_count FROM (
    SELECT 
        course,
        job_role,
        COUNT(*) AS role_count,
        RANK() OVER (PARTITION BY course ORDER BY COUNT(*) DESC) AS role_rank
    FROM placements
    GROUP BY course, job_role
) sub
WHERE role_rank <= 3;

--City-wise Average Salary & Company Count

SELECT 
    location,
    ROUND(AVG(salary_inr)) AS avg_salary,
    COUNT(DISTINCT company) AS total_companies,
    COUNT(*) AS total_placements
FROM placements
GROUP BY location
ORDER BY avg_salary DESC;


CREATE TABLE placement_insight_summary (
    insight_name VARCHAR(100),
    category_1 VARCHAR(100),
    category_2 VARCHAR(100),
    metric_1 VARCHAR(100),
    metric_2 VARCHAR(100),
    metric_3 VARCHAR(100)
);

-- City-wise Salary & Company Count
INSERT INTO placement_insight_summary (insight_name, category_1, metric_1, metric_2, metric_3)

SELECT 
    'Top Cities by Avg Salary and Hiring' AS insight_name,
    location,
    CONCAT('₹', ROUND(AVG(salary_inr))) AS avg_salary,
    CONCAT(COUNT(DISTINCT company), ' companies') AS company_count,
    CONCAT(COUNT(*), ' placements') AS placement_count
FROM placements
GROUP BY location
ORDER BY AVG(salary_inr) DESC
LIMIT 5;

--Average Salary by Branch

CREATE TABLE avg_salary_by_branch (
    branch VARCHAR(50),
    avg_salary INT
);

INSERT INTO avg_salary_by_branch
SELECT Branch, ROUND(AVG(Salary_INR)) AS avg_salary
FROM placements
GROUP BY Branch
ORDER BY avg_salary DESC;

--Placement Rate by Graduation Year
CREATE TABLE placements_by_graduation_year (
    graduation_year INT,
    placements INT
);

INSERT INTO placements_by_graduation_year (graduation_year, placements)
SELECT Graduation_Year, COUNT(*) AS placements
FROM placements
GROUP BY Graduation_Year
ORDER BY Graduation_Year;
select * from  placements_by_graduation_year

--Popular Job Roles and Their Avg Salaries
CREATE TABLE popular_roles (
    job_role VARCHAR(100),
    role_count INT,
    avg_salary INT
);

INSERT INTO popular_roles
SELECT Job_Role, COUNT(*) AS role_count, ROUND(AVG(Salary_INR)) AS avg_salary
FROM placements
GROUP BY Job_Role
ORDER BY role_count DESC
LIMIT 5;

--Branch Performance Comparison
CREATE TABLE top_roles_per_course (
    course VARCHAR(50),
    job_role VARCHAR(100),
    role_count INT
);

INSERT INTO top_roles_per_course
SELECT course, job_role, role_count FROM (
    SELECT 
        course,
        job_role,
        COUNT(*) AS role_count,
        RANK() OVER (PARTITION BY course ORDER BY COUNT(*) DESC) AS role_rank
    FROM placements
    GROUP BY course, job_role
) sub
WHERE role_rank <= 3;








--join 8
SELECT regions.region_id, region_name, country_name
FROM countries, regions
WHERE regions.region_id = countries.region_id
AND region_name IN('Europe');

--join 9
SELECT regions.region_id, region_name, country_name, city
FROM countries, regions, locations
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND region_name IN('Europe');

--join 10
SELECT regions.region_id, region_name, country_name, city, department_name
FROM countries, regions, locations, departments
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND region_name IN('Europe');

--join 11
SELECT regions.region_id, region_name, country_name, city, department_name, employee_id, first_name || last_name name
FROM countries, regions, locations, departments, employees
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND departments.department_id = employees.department_id
AND region_name IN('Europe');

--join 12
SELECT employee_id, first_name || last_name name, jobs.job_id, job_title 
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

--join 13¹ø °úÁ¦
SELECT  b.manager_id mgn_id, a.first_name || a.last_name mgr_name, b.employee_id,
        b.first_name || b.last_name name, a.job_id, job_title 
FROM employees a, employees b, jobs
WHERE b.job_id = jobs.job_id
AND b.manager_id = a.employee_id
ORDER BY b.manager_id;



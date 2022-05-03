use employees_mod;

select 
year(de.from_date) as Employment_year,
e.gender,
count(e.emp_no)
from t_employees e
left join t_dept_emp de on e.emp_no = de.emp_no
group by
e.gender,
Employment_year
having employment_year > '1989'
order by employment_year;

select
d.dept_name,
e.gender,
dm.emp_no,
dm.from_date,
dm.to_date,
v.calendar_year,
case
when v.calendar_year between year(dm.from_date) and year(dm.to_date) then 1 else 0
end as active  
from
(select year(hire_date) as calendar_year
from
t_employees
group by calendar_year) v
cross join
t_dept_manager dm
left join
t_departments d on d.dept_no = dm.dept_no
left join
t_employees e on e.emp_no = dm.emp_no
order by dm.emp_no, calendar_year;
;

select year(hire_date) as test
from t_employees
group by test;
 
alter table t_employees
add salary_year2 float;

alter table t_employees
add paid_year int;

update t_employees set salary_year2 = year(t_employees.hire_date);

drop table t_emp_sal;

create table t_emp_sal(
emp_no int,
from_date date,
to_date date,
salary_year2 year,
salary int,
gender varchar(255),
deparment_number varchar(255));

select * from t_emp_sal;

insert INTO t_emp_sal
SELECT t_employees.emp_no, t_salaries.from_date, t_salaries.to_date, 
t_employees.salary_year2, t_salaries.salary, t_employees.gender, t_dept_emp.dept_no
FROM t_salaries
INNER JOIN t_employees ON t_employees.emp_no = t_salaries.emp_no
LEFT JOIN t_dept_emp on t_employees.emp_no = t_dept_emp.emp_no;

select * from t_salaries
where emp_no not in (select emp_no from t_employees);

select * from t_employees;

select * from t_emp_sal;

update t_employees set salary_year = case
when salary_year between year(s.from_date) and year(s.to_date) then s.salary else 0
end;

select * from t_employees;

select
d.dept_name,
e.gender,
e.emp_no,
s.from_date,
s.to_date,
v.calendar_year,
s.salary,
case
when v.calendar_year between year(s.from_date) and year(s.to_date) then s.salary else 0
end as salary_year, 
avg(salary_year)
from 

(select year(hire_date) as calendar_year
from
t_employees
group by calendar_year) v
cross join
t_employees e
left join
t_dept_emp de on de.emp_no = e.emp_no
left join
t_departments d on d.dept_no = de.dept_no
left join
t_salaries s on s.emp_no = e.emp_no
group by
calendar_year, gender
order by e.emp_no, calendar_year;

SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;

DELIMITER $$

drop procedure if exists `min_max_salary`;

create PROCEDURE `min_max_salary` (in param_1 float, in param_2 float)
BEGIN
select t_employees.gender, t_departments.dept_name, avg(t_salaries.salary)
from t_employees
inner join t_salaries on t_employees.emp_no = t_salaries.emp_no
inner join t_dept_emp on t_employees.emp_no = t_dept_emp.emp_no
inner join t_departments on t_departments.dept_no = t_dept_emp.dept_no
where t_salaries.salary between param_1 and param_2
group by
t_employees.gender, t_dept_emp.dept_no;

END $$
DELIMITER ;

call min_max_salary(50000,100000);

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;

SELECT 

    YEAR(d.from_date) AS calendar_year,
    e.gender,    
    COUNT(e.emp_no) AS num_of_employees

FROM     
     t_employees e         
          JOIN    
     t_dept_emp d ON d.emp_no = e.emp_no

GROUP BY calendar_year , e.gender 

HAVING calendar_year >= 1990;

-- 1) Сделать выборку всех работников с именем “Давид” из отдела “Снабжение” с полями ФИО, заработная плата, должность

SELECT full_name AS "ФИО", salary AS "Заработная плата", positions.position_name AS "Должность"
FROM employees 
JOIN departments ON employees.department_id = departments.department_id 
JOIN positions ON employees.position_id = positions.position_id 
WHERE full_name LIKE 'Давид%' AND departments.department_name = 'Снабжение';

-- 2) Посчитать среднюю заработную плату работников по отделам

SELECT departments.department_name AS "Отдел", AVG(salary) AS "Средняя заработная плата"
FROM employees 
JOIN departments ON employees.department_id = departments.department_id 
GROUP BY departments.department_name;

-- 3) Сделать выборку по должностям, в результате которой отобразятся данные,
-- больше ли средняя ЗП по должности, чем средняя ЗП по всем работникам.

SELECT AVG(salary) AS "Средняя ЗП по всем сотрудникам" FROM employees;
-- узнали что средняя зп 95000

WITH avg_salary AS (
    SELECT AVG(salary) AS value FROM employees
)
SELECT positions.position_name AS "Должность", AVG(employees.salary) AS "Средняя ЗП по должности", 
CASE WHEN AVG(employees.salary) > avg_salary.value THEN 'Да' ELSE 'Нет' END AS "Больше ли общей средней ЗП"
FROM employees 
JOIN positions ON employees.position_id = positions.position_id, avg_salary
GROUP BY positions.position_name, avg_salary.value;

-- 4) Сделать представление, в котором собраны данные по должностям (Должность,
-- в каких отделах встречается эта должность 
-- (в виде массива), список сотрудников, начавших работать в этом отделе 
-- не раньше 2021 года (Сгруппировать по отделам) (в формате JSON), 
-- средняя заработная плата по должности)

CREATE OR REPLACE VIEW position_view AS 
SELECT positions.position_name AS "Должность", 
ARRAY_AGG(DISTINCT departments.department_name) AS "Отделы",
JSON_AGG(
    CASE WHEN employees.start_date >= '2021-01-01' THEN employees.full_name ELSE NULL END
) FILTER (WHERE employees.start_date >= '2021-01-01') AS "Список сотрудников с начала 2021 года",
AVG(employees.salary) AS "Средняя ЗП"
FROM employees 
JOIN positions ON employees.position_id = positions.position_id 
JOIN departments ON employees.department_id = departments.department_id 
GROUP BY positions.position_name;

select * from position_view;
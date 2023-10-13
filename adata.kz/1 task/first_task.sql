-- 1) ������� ������� ���� ���������� � ������ ������ �� ������ ���������� � ������ ���, ���������� �����, ���������

SELECT full_name AS "���", salary AS "���������� �����", positions.position_name AS "���������"
FROM employees 
JOIN departments ON employees.department_id = departments.department_id 
JOIN positions ON employees.position_id = positions.position_id 
WHERE full_name LIKE '�����%' AND departments.department_name = '���������';

-- 2) ��������� ������� ���������� ����� ���������� �� �������

SELECT departments.department_name AS "�����", AVG(salary) AS "������� ���������� �����"
FROM employees 
JOIN departments ON employees.department_id = departments.department_id 
GROUP BY departments.department_name;

-- 3) ������� ������� �� ����������, � ���������� ������� ����������� ������,
-- ������ �� ������� �� �� ���������, ��� ������� �� �� ���� ����������.

SELECT AVG(salary) AS "������� �� �� ���� �����������" FROM employees;
-- ������ ��� ������� �� 95000

WITH avg_salary AS (
    SELECT AVG(salary) AS value FROM employees
)
SELECT positions.position_name AS "���������", AVG(employees.salary) AS "������� �� �� ���������", 
CASE WHEN AVG(employees.salary) > avg_salary.value THEN '��' ELSE '���' END AS "������ �� ����� ������� ��"
FROM employees 
JOIN positions ON employees.position_id = positions.position_id, avg_salary
GROUP BY positions.position_name, avg_salary.value;

-- 4) ������� �������������, � ������� ������� ������ �� ���������� (���������,
-- � ����� ������� ����������� ��� ��������� 
-- (� ���� �������), ������ �����������, �������� �������� � ���� ������ 
-- �� ������ 2021 ���� (������������� �� �������) (� ������� JSON), 
-- ������� ���������� ����� �� ���������)

CREATE OR REPLACE VIEW position_view AS 
SELECT positions.position_name AS "���������", 
ARRAY_AGG(DISTINCT departments.department_name) AS "������",
JSON_AGG(
    CASE WHEN employees.start_date >= '2021-01-01' THEN employees.full_name ELSE NULL END
) FILTER (WHERE employees.start_date >= '2021-01-01') AS "������ ����������� � ������ 2021 ����",
AVG(employees.salary) AS "������� ��"
FROM employees 
JOIN positions ON employees.position_id = positions.position_id 
JOIN departments ON employees.department_id = departments.department_id 
GROUP BY positions.position_name;

select * from position_view;
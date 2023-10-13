CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL
);

CREATE TABLE positions (
    position_id SERIAL PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    position_id INT REFERENCES positions(position_id),
    department_id INT REFERENCES departments(department_id),
    salary INT NOT NULL,
    start_date DATE NOT NULL
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    role_id INT REFERENCES roles(role_id),
    employee_id INT REFERENCES employees(employee_id)
);

INSERT INTO departments (department_name) VALUES ('Снабжение'), ('Разработка');
INSERT INTO positions (position_name) VALUES ('Менеджер'), ('Дизайнер');
INSERT INTO employees (full_name, position_id, department_id, salary, start_date) 
VALUES 
('Давид Манукян', 1, 1, 60000, '2023-01-01'),
('Давид Микеланджело', 2, 1, 110000, '2023-01-01');
INSERT INTO roles (role_name) VALUES ('Руководитель проекта'), ('Разработчик');
INSERT INTO projects (project_name, role_id, employee_id) VALUES ('Проект 1', 1, 1), ('Проект 2', 2, 2);
INSERT INTO employees (full_name, position_id, department_id, salary, start_date) 
VALUES 
('Johnson John', 1, 2, 80000, '2023-09-09'),
('Cristiano Ronaldo', 2, 2, 130000, '2023-05-03');
select * from departments;

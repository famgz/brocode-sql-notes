CREATE DATABASE myDB;

USE myDB;

DROP DATABASE myDB;

ALTER DATABASE myDB READ ONLY = 1;

DROP DATABASE myDB; -- cannot cause of the READ ONLY

CREATE TABLE employees (
        employee_id INT,
        first_name VARCHAR(50), -- 50: max
        last_name VARCHAR(50),
        hourly_pay DECIMAL(5, 2), -- 5: max amount of digits, 2: precision
        hire_date DATE
);

SELECT * FROM employees;

RENAME TABLE employess TO workers;

DROP TABLE employees;

ALTER TABLE employees
ADD phone_number VARCHAR(15);

ALTER TABLE employees
RENAME COLUMN phone_number to email;

ALTER TABLE employees
MODIFY COLUMN email VARCHAR(100);

-- move column
ALTER TABLE employees
MODIFY email VARCHAR(100)
AFTER last_name;  -- FIRST: to be first column

-- drop column
ALTER TABLE employees
DROP COLUMN email;

-- insert row with all data
INSET INTO employees -- not specifying the columns will require to input all
VALUES (1, "Eugene", "Krabs", 25.50, "2023-01-02");

-- insert multiple rows with all data, will error if any column missing
INSERT INTO employees
VALUES 
    (2, "Squidward", "Tentacles", 15.00, "2023-01-03"),
    (3, "Spongebob", "Squarepants". 12.50, "2023-01-04"),
    (4, "Patrick", "Star". 17.50, "2023-01-05"),
    (5, "Sheldon", "Plankton")  --missing data

-- insert row with missing data
INSERT INTO employees (employee_id, first_name, last_name)
VALUES 
    (6, "Sheldon", "Plankton");

-- select specific columns
SELECT first_name, last_name
FROM employees;

-- select with condition
SELECT *
FROM employees
WHERE employee_id = 1;

SELECT *
FROM employees
WHERE hourly_pay >= 15;

SELECT *
FROM employees
WHERE employee_id != 1;

SELECT *
FROM employees
WHERE hire_date IS NOT NULL; -- = NULL doesn`t work

-- update row
UPDATE employees
SET hourly_pay = 10.99,
    hire_date = "2023-01-07"
WHERE employee_id = 3; -- if not specified will change all rows

-- delete all rows
DELETE FROM employee; -- will delete all rows in the table!

-- delete row
DELETE FROM employee
WHERE employee_id = 4;


-- undo changes
SET AUTOCOMMIT = OFF; -- transaction won't be saved automatically, need to manually save each (COMMIT) transaction

COMMIT; -- create a safe point

DELETE FROM employees;

ROLLBACACK; -- restore to the previous safe point



--* dates and times
CREATE TABLE test(
    my_date DATE,
    my_time TIME,
    my_datetime DATETIME,
);

-- get current dates and times
INSERT INTO test
VALUES(CURRENT_DATE(), CURRENT_TIME(), NOW()); -- CURRENT_DATE() + 1 : tomorrow | CURRENT_TIME() - 2000 (seconds)


--* constraints
-- UNIQUE constraint at creation
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(25) UNIQUE,
    price DECIMAL(4, 2)
);

-- UNIQUE constraint afterwards
ALTER TABLE products
ADD CONSTRAINT
UNIQUE(product_name);

-- NOT NULL constraint at creation
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(25),
    price DECIMAL(4, 2) NOT NULL
);

-- NOT NULL constraint afterwards
ALTER TABLE products
MODIFY price DECIMAL(4, 2) NOT NULL;


-- CHECK constraint at creation
CREATE TABLE employees (
        employee_id INT,
        first_name VARCHAR(50), -- 50: max
        last_name VARCHAR(50),
        hourly_pay DECIMAL(5, 2), -- 5: max amount of digits, 2: precision
        hire_date DATE,
        --CHECK  (hourly_pay >= 10.00) -- constraint without name
        CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00)  -- constraint with a name
);

-- CHECK constraint afterwards
ALTER TABLE employees
ADD CONSTRAINT chk_hourly_pay CHECK(hourly_pay >= 10.00);

-- remove CHECK constraint
ALTER TABLE employees
DROP CHECK chk_hourly_pay

-- DEFAULT constraint at creation
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(25),
    price DECIMAL(4, 2) DEFAULT 0.0,
    insert_date DATETIME DEFAULT NOW()
);

-- DEFAULT constraint afterwards
ALTER TABLE products
ALTER price SET DEFAULT 0.00;
ALTER insert_date SET DEFAULT NOW();

-- PRIMARY constraint at creation
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY, -- can only have 1 per table
    amout DECIMAL(5, 2)
)

-- PRIMARY constraint afterwards
ALTER TABLE transactions
ADD CONSTRAINT
PRIMARY KEY(transaction_id);

-- AUTO_INCREMENT feature
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY AUTO_INCREMENT, -- defaults to starts with 1
    amout DECIMAL(5, 2)
);

-- to begin with specific value
ALTER TABLE transactions
AUTO_INCREMENT = 1000;



--* FOREIGN KEY
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amout DECIMAL(5, 2),
    customer_id INT
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id) -- will apply a default name `transactions_ibfk_1`
);

-- drop FOREIGN KEY
ALTER TABLE transactions
DROP FOREIGN KEY transactions_ibfk_1; -- auto generated key name

-- give FOREIGN KEY an unique name
ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(customer_id);



--* JOIN
-- INNER JOIN
SELECT transaction_id, amount, first_name, last_name
FROM transactions INNER JOIN customers
ON transactions.customer_id = customers.customer_id;

-- LEFT/RIGHT  JOIN
SELECT transaction_id, amount, first_name, last_name
FROM transactions LEFT JOIN customers
ON transactions.customer_id = customers.customer_id;


--* functions
-- COUNT
SELECT COUNT(amount) AS count -- alias
FROM transactions;

-- MAX / MIN / AVG / SUM
SELECT MAX(amount) AS maximum
FROM transactions;

-- CONCAT
SELECT CONCAT(first_name, " ", last_name) AS full_name -- added a space between words
FROM employees;

-- AND / OR / NOT / BETWEEN / IN
SELECT *
FROM employees
WHERE hire_date < "2023-01-5" AND job = "cook";

WHERE NOT job = "manager" AND NOT job = "asst. manager";
WHERE hire_date BETWEEN "2023-01-04" AND "2023-01-07";
WHERE job in ("cook", "cashier", "janitor");


--* wild characters % _ | %: 0,n chars | _: 1 char
SELECT *
FROM employees
WHERE first_name LIKE "s%"; -- names that begins with letter "s"

WHERE hire_date LIKE "2023%"
WHERE hire_date LIKE "____-01-__"; -- dates in january
WHERE job LIKE "_a%"; -- second char "a"


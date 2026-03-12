
-- LEVEL 1 
-- EXERCISE 1

    -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );


    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) PRIMARY KEY,
        credit_card_id VARCHAR(15), -- <-Removed the reference to a table that does not exist
        company_id VARCHAR(20), 
        user_id INT, -- <-Removed the reference to a table that does not exist
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        FOREIGN KEY (company_id) REFERENCES company(id) 
    );

-- IMPORTANT! INSERT THE DATA BEFORE PROCEEDING

-- LEVEL 1
-- EXERCISE 2
SELECT DISTINCT c.country
FROM transaction AS t
LEFT JOIN company AS c
ON c.id = t.company_id ;


SELECT t.company_id, c.company_name, t.amount
FROM transaction AS t
LEFT JOIN company AS c
ON c.id = t.company_id
ORDER BY t.amount DESC
LIMIT 1;


-- LEVEL 1
-- EXERCISE 3
SELECT * 
FROM transaction 
WHERE company_id IN (
    SELECT id 
    FROM company 
    WHERE country = 'Germany');

SELECT company_name 
FROM company 
WHERE id IN (
    SELECT company_id 
    FROM transaction 
    WHERE amount > (
        SELECT AVG(amount) 
        FROM transaction));

SELECT id, company_name 
FROM company 
WHERE id IN (
    SELECT company_id 
    FROM transaction);

-- LEVEL 2
-- EXERCISE 1

SELECT DATE(timestamp), SUM(amount)  as total
FROM transaction
GROUP BY DATE(timestamp)
ORDER BY total DESC
LIMIT 5;

-- LEVEL 2 
-- EXERCISE 2

SELECT AVG(t.amount), c.country
FROM transaction as t
LEFT JOIN company as c
ON t.company_id = c.id
GROUP BY c.country;

-- LEVEL 2
-- EXERCISE 3

SELECT *
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE c.country = (
SELECT country FROM company WHERE company_name = 'Non Institute')

SELECT *
FROM transaction
WHERE company_id IN (
SELECT DISTINCT id
FROM company 
WHERE country = (
SELECT country FROM company WHERE company_name = 'Non Institute'))

-- LEVEL 3
-- EXERCISE 1

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp), t.amount
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE (t.amount > 350 AND t.amount < 400) 
AND (DATE(t.timestamp) = '2015-04-29' OR DATE(t.timestamp) = '2018-07-20' OR DATE(t.timestamp) = '2024-03-13')
ORDER BY t.amount DESC

-- LEVEL 3
-- EXERCISE 2

SELECT  c.company_name, COUNT(*) as num_transaction_company
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
GROUP BY c.company_name
HAVING num_transaction_company > 400
ORDER BY num_transaction_company DESC






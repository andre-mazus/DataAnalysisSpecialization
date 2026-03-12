

-- CREATING THE DATABASE
CREATE DATABASE IF NOT EXISTS sprint4;
USE sprint4;


-- CREATING THE TABLES
 CREATE TABLE IF NOT EXISTS companies (
    id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(150),
    country VARCHAR(100),
    website VARCHAR(255)
    );

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    birth_date DATE,
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS credit_cards (
    id VARCHAR(20) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(50),
    pan VARCHAR(100),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(10),
    FOREIGN KEY (user_id) REFERENCES users(id) 
);

CREATE TABLE IF NOT EXISTS products(
    id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10, 2),
    colour VARCHAR(20),
    weight FLOAT,
    warehouse_id VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS transactions (
    id VARCHAR(100) PRIMARY KEY,
    card_id VARCHAR(20),
    company_id VARCHAR(15),
    timestamp TIMESTAMP,
    amount DECIMAL(10, 2),
    declined BOOLEAN,
    product_ids INT,
    user_id INT,
    lat FLOAT,
    longitude FLOAT,
    FOREIGN KEY (card_id) REFERENCES credit_cards(id),
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (product_ids) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
-- BEFORE INSERTING THE DATA I HAD TO CLEAN AND FORMART IT ON EXCEL, MAKING SURE ALL THE DATATYPES WERE CONSISTENT, SPECIALLY DATES.

-- INSERTING THE DATA

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;




-- LEVEL 1 
-- EXERCISE 1

SELECT count(*) AS num_trasactions, (
	SELECT  u.email
    FROM users AS u
    WHERE t.user_id = u.id) AS user_email
FROM transactions AS t
GROUP BY t.user_id
HAVING num_trasactions > 80
ORDER BY num_trasactions DESC;

-- LEVEL 1 
-- EXERCISE 2

SELECT AVG(t.amount),  cc.iban
FROM transactions AS t
LEFT JOIN companies AS C ON t.company_id = c.id
LEFT JOIN credit_cards AS cc ON t.card_id = cc.id
WHERE c.company_name = "Donec Ltd"
GROUP BY cc.iban

-- LEVEL 2
-- EXERCISE 1

CREATE TABLE IF NOT EXISTS credit_cards_status (
    id VARCHAR(20) PRIMARY KEY,
    status VARCHAR(10),
    FOREIGN KEY (id) REFERENCES credit_cards(id)
);

INSERT INTO credit_cards_status (id, status)
    SELECT card_id,
    -- MAX(CASE WHEN lastTransactions= 1 THEN declined END) AS lastTransaction,
    -- MAX(CASE WHEN lastTransactions= 2 THEN declined END) AS Secondlast,
    -- MAX(CASE WHEN lastTransactions= 3 THEN declined END) AS Thirdlast,
    CASE WHEN SUM(CASE WHEN declined = 1 THEN 1 ELSE 0 END) = 3 THEN 'INACTIVE'ELSE 'ACTIVE' END AS status
    FROM (
        SELECT card_id, declined, ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY timestamp DESC) as lastTransactions 
        FROM transactions) as lastTransactionsTT
    WHERE lastTransactions <=3
    GROUP BY card_id;

SELECT COUNT(*)
FROM credit_cards_status
WHERE status = "ACTIVE";

-- LEVEL 3
-- EXERCISE 1

CREATE TABLE IF NOT EXISTS products(
    id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10, 2),
    colour VARCHAR(20),
    weight FLOAT,
    warehouse_id VARCHAR(10)
);

LOAD DATA LOCAL INFILE '/Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint4/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

ALTER TABLE transactions
ADD FOREIGN KEY (product_ids) REFERENCES products(id);

SELECT DISTINCT(t.product_ids) AS product_id, p.product_name,COUNT(*) AS unities_sold
FROM transactions AS t
LEFT JOIN products AS p ON t.product_ids = p.id
GROUP BY product_ids;









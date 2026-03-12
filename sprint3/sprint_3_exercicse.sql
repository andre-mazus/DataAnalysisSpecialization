-- LEVEL 1
-- EXERCISE 1


CREATE TABLE IF NOT EXISTS credit_card (
	id varchar(15) PRIMARY KEY, -- <- same data type as transaction.credit_card_id
	iban VARCHAR(40), -- <- IBAN max num character 34. created it with 40 for some margin
	pan VARCHAR(40),
	pin CHAR(4),
	cvv CHAR(3),
	expiring_date VARCHAR(10) -- <- I would create it with DATA type but would have to change all the inserts.
);

ALTER TABLE transaction -- <- ALTER the data type so it can be reference with new create table
MODIFY COLUMN  user_id CHAR(10); 

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

-- LEVEL 1
-- EXERCISE 2

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT * 
FROM credit_card
WHERE id = 'CcU-2938';

-- LEVEL 1 
-- EXERCICE 3

INSERT INTO credit_card(id) VALUES("CcU-9999");

INSERT INTO company (id) VALUES ("b-9999");

INSERT INTO user (id) VALUES ("9999")



INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) VALUES ('	108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999','b-9999', '9999', '829.999', '-117.999', '111.11', '	0'); -- <- I will get an error because there is no user with this id in the table user and because it is a FK it can not be create.

-- LEVEL 1
-- EXERCISE 4

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * 
FROM credit_card;

-- LEVEL 2 
-- EXERCISE 1

DELETE FROM transaction WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- LEVEL 2
-- EXERCISE 2

CREATE view VistaMarketing AS
		SELECT c.company_name, c.phone, c.country,  CAST(AVG(t.amount) as DECIMAL (10,2)) as Average_purchase
		FROM company as c
		LEFT JOIN transaction as t
		ON c.id = t.company_id
		GROUP BY c.company_name, c.phone,  c.country
		ORDER BY Average_purchase DESC;

SELECT * 
FROM VistaMarketing

-- LEVEL 2
-- EXERCISE 3

SELECT * 
FROM VistaMarketing
WHERE country = 'Germany'

-- LEVEL 3
-- EXERCISE 1

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR(50);

ALTER TABLE credit_card
DROP COLUMN pan;

ALTER TABLE credit_card
MODIFY COLUMN pin VARCHAR(4);

ALTER TABLE credit_card
MODIFY COLUMN cvv INT;

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(20);

ALTER TABLE credit_card
ADD COLUMN fecha_atual DATE;

UPDATE credit_card
SET fecha_atual = NOW() -- <- It is not necessary, just for testing propouse.

ALTER TABLE company
DROP COLUMN website;

-- This step was fun. I wanted to change the datatype of user.id but to do it before I had to DROP the FK in the table transaction. To do it I used the two following queries and then  I changed the datatype in both tables, user.id and transaction.user_id. With both columns being the same datatype I add the reference again to make it FK.

SHOW CREATE TABLE transaction;

ALTER TABLE transaction
DROP FOREIGN KEY transaction_ibfk_2 

ALTER TABLE user
MODIFY COLUMN id INT;

ALTER TABLE transaction
MODIFY COLUMN user_id INT;

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);


ALTER TABLE user
RENAME COLUMN email to personal_email;

ALTER TABLE user
RENAME to data_user;

ALTER TABLE transaction
MODIFY COLUMN credit_card_id VARCHAR(20);


-- LEVEL 3
-- EXERCISE 2

CREATE VIEW TechnicalReport AS
	SELECT t.id AS transaction_id, 
		u.name AS user_name, 
		u.surname AS user_surname, 
		cc.iban, 
		c.company_name
	FROM transaction AS t
	LEFT JOIN user AS u ON t.user_id = u.id 
	LEFT JOIN credit_card AS cc ON t.credit_card_id = cc.id
	LEFT JOIN company AS c ON t.company_id = c.id;

SELECT * 
FROM TechnicalReport
ORDER BY transaction_id DESC;


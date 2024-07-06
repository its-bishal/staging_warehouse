

-- DDL language to create the table

-- The  table consists of all the values worked on along with
CREATE TABLE sw_001_extenso.sp_sw_table(
	id INT AUTO_INCREMENT PRIMARY KEY,
	txn_id INT,
	created_date DATE,
	payer_account_id INT,
	module_id INT,
	product_id INT,
	product_type_id INT,
	total_amount INT,
	avg_amount INT,
	total_transactions INT,
	created_on DATE DEFAULT (CURRENT_DATE),
	created_by VARCHAR(10) DEFAULT 'bishal',
	updated_on DATE DEFAULT NULL,
	updated_by VARCHAR(10) DEFAULT NULL
);
DROP TABLE sw_001_extenso.sp_sw_table;


-- procedure to write to the table
DELIMITER //
CREATE PROCEDURE sw_table_insert(sdate DATE, edate DATE)
BEGIN
	INSERT INTO sw_001_extenso.sp_sw_table (txn_id, created_date, payer_account_id, module_id, product_id, product_type_id, total_amount, avg_amount, total_transactions) (
		SELECT trans.txn_id, trans.created_date, trans.payer_account_id, trans.module_id, trans.product_id, trans.product_type_id, SUM(trans.amount), AVG(trans.amount), COUNT(trans.txn_id)
		FROM sw_001_extenso.rw_transaction_data AS trans 
		JOIN sw_001_extenso.product_category_map AS prod
		USING (module_id, product_id, product_type_id)
    
		WHERE trans.created_date BETWEEN sdate AND edate
		GROUP BY trans.txn_id, trans.created_date, trans.payer_account_id, trans.module_id, trans.product_id, trans.product_type_id ORDER BY trans.created_date);

END //
DELIMITER ;


DROP PROCEDURE sw_001_extenso.sw_table_insert;
CALL sw_001_extenso.sw_table_insert('2023-05-03', '2023-05-03');
CALL sw_001_extenso.sw_table_insert('2023-05-04', '2023-05-04');

SELECT * FROM sw_001_extenso.sp_sw_table WHERE created_date BETWEEN '2023-05-04' AND '2023-05-04';



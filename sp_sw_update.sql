

-- procedure to create table if not already existing and then append values to it
-- this solves the problem of duplication in update
-- the transactions already updated are removed if same date is passed to the procedure
-- and then updates the values for the passed date
DELIMITER //

CREATE PROCEDURE sw_001_extenso.sp_sw_daily_update(newdate DATE)
BEGIN
	CREATE TABLE IF NOT EXISTS sw_001_extenso.sp_sw_daily_update(
		created_date DATE,
		payer_account_id INT,
		module_id INT,
		product_id INT,
		product_type_id INT,
		total_amount INT,
		avg_amount INT,
		total_transactions INT
	);
    -- DELETE THE PREVIOUS TRANSACTION VALUES IF THEY EXIST FOR THE SAME PASSED DATE
	DELETE FROM sw_001_extenso.sp_sw_daily_update WHERE newdate = created_date;

	INSERT INTO sw_001_extenso.sp_sw_daily_update (created_date, payer_account_id, module_id, product_id, product_type_id,
	                                               total_amount, avg_amount, total_transactions)
	    (
		SELECT trans.created_date, trans.payer_account_id, trans.module_id, trans.product_id,
		       trans.product_type_id, SUM(trans.amount), AVG(trans.amount), COUNT(trans.txn_id)
		FROM sw_001_extenso.rw_transaction_data AS trans
		JOIN sw_001_extenso.product_category_map AS prods
		USING (module_id, product_id, product_type_id)

		WHERE trans.created_date BETWEEN newdate AND newdate
		GROUP BY trans.created_date, trans.payer_account_id, trans.module_id, trans.product_id, trans.product_type_id ORDER BY trans.created_date
		)

	   ON DUPLICATE KEY UPDATE
        total_amount = VALUES(total_amount),
        avg_amount = VALUES(avg_amount),
        total_transactions = VALUES(total_transactions);

END //
DELIMITER ;

CALL sw_001_extenso.sp_sw_daily_update('2023-05-03');
CALL sw_001_extenso.sp_sw_daily_update('2023-05-04');

select count(*) from  sw_001_extenso.sp_sw_daily_update;

DROP TABLE sw_001_extenso.sp_sw_daily_update;
DROP PROCEDURE sw_001_extenso.sp_sw_daily_update;

-- check if the values are updated to the table
SELECT * FROM sw_001_extenso.sp_sw_daily_update WHERE created_date BETWEEN '2023-05-04' AND '2023-05-04';


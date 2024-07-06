# create a procedure to create a table and append the monthly aggregation values
DELIMITER //
CREATE PROCEDURE sw_001_extenso.sp_sw_monthly(newdate DATE)
BEGIN
    CREATE TABLE IF NOT EXISTS sw_001_extenso.sp_sw_monthly
    (
        created_date       DATE,
        payer_account_id   INT,
        module_id          INT,
        product_id         INT,
        product_type_id    INT,
        total_amount       INT,
        avg_amount         INT,
        total_transactions INT
    );


    ALTER TABLE sw_001_extenso.rw_transaction_data
        ADD COLUMN monthly_date DATE;
    UPDATE sw_001_extenso.rw_transaction_data SET monthly_date = DATE_FORMAT(created_date, '%Y-%m-01');

    DELETE FROM sw_001_extenso.sp_sw_monthly WHERE created_date = newdate;

    INSERT INTO sw_001_extenso.sp_sw_monthly (created_date, payer_account_id, module_id, product_id, product_type_id,
                                              total_amount, avg_amount, total_transactions)
        (SELECT trans.created_date,
                trans.payer_account_id,
                trans.module_id,
                trans.product_id,
                trans.product_type_id,
                SUM(trans.amount),
                AVG(trans.amount),
                COUNT(trans.txn_id)
         FROM sw_001_extenso.rw_transaction_data AS trans
                  JOIN sw_001_extenso.product_category_map AS prod
                       USING (module_id, product_id, product_type_id)
         WHERE trans.monthly_date = newdate
         GROUP BY trans.created_date, trans.payer_account_id, trans.module_id, trans.product_id, trans.product_type_id
         ORDER BY trans.created_date);

    ALTER TABLE sw_001_extenso.rw_transaction_data
        DROP COLUMN monthly_date;

END //
DELIMITER ;


DROP PROCEDURE sw_001_extenso.sp_sw_monthly;
CALL sw_001_extenso.sp_sw_monthly('2023-02-01');
CALL sw_001_extenso.sp_sw_monthly('2023-01-01');

DROP TABLE sw_001_extenso.sp_sw_monthly;
SELECT * FROM sw_001_extenso.sp_sw_monthly;


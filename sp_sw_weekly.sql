

-- retrieve weekly data from as specified by the id selected for the md_weekly table
DELIMITER //
CREATE PROCEDURE sw_001_extenso.sp_sw_weekly(newid INT)
BEGIN
    DECLARE startdate DATE;
    DECLARE enddate DATE;

    SELECT start_date, end_date INTO startdate, enddate FROM sw_001_extenso.md_weekly WHERE id = newid;

    CREATE TABLE sp_sw_weekly AS
        SELECT trans.created_date,
               SUM(trans.amount),
               AVG(trans.amount),
               COUNT(trans.txn_id),
               trans.payer_account_id,
               trans.module_id,
               trans.product_id,
               trans.product_type_id
        FROM sw_001_extenso.rw_transaction_data AS trans
                 JOIN sw_001_extenso.product_category_map AS prod
                      USING (module_id, product_id, product_type_id)

        WHERE trans.created_date BETWEEN startdate AND enddate
        GROUP BY trans.payer_account_id, trans.module_id, trans.product_id, trans.product_type_id, trans.created_date
        ORDER BY trans.created_date;

    SELECT * FROM sw_001_extenso.sp_sw_weekly;
END //
DELIMITER ;

CALL sw_001_extenso.sp_sw_weekly(1);

DROP PROCEDURE sw_001_extenso.sp_sw_weekly;
DROP TABLE sw_001_extenso.sp_sw_weekly;
SELECT * FROM sw_001_extenso.sp_sw_weekly;



-- looping integrated with the md_weekly table to return temp tables for all the dates specified separately by ids
DELIMITER //
CREATE PROCEDURE looping()
BEGIN
    DECLARE id1 INT DEFAULT 0;
    DECLARE start_1 DATE;
    DECLARE end_1 DATE;

    DECLARE idmax INT DEFAULT (SELECT MAX(id) FROM sw_001_extenso.md_weekly);

    loop1 :
    LOOP
        SET id1 = id1 + 1;

        IF id1 > idmax THEN
            LEAVE loop1;
        END IF;
        SELECT start_date, end_date INTO start_1, end_1 FROM sw_001_extenso.md_weekly WHERE id = id1;

        SELECT trans.created_date,
               SUM(trans.amount),
               AVG(trans.amount),
               COUNT(trans.txn_id),
               trans.payer_account_id,
               trans.module_id,
               trans.product_id,
               trans.product_type_id
        FROM sw_001_extenso.rw_transaction_data AS trans
                 JOIN sw_001_extenso.product_category_map AS prod
                      USING (module_id, product_id, product_type_id)

        WHERE trans.created_date BETWEEN start_1 AND end_1
        GROUP BY trans.payer_account_id, trans.module_id, trans.product_id, trans.product_type_id, trans.created_date
        ORDER BY trans.created_date;

    END LOOP;
END //
DELIMITER ;

CALL looping();
DROP PROCEDURE looping;
SELECT *
FROM sw_001_extenso.md_weekly;






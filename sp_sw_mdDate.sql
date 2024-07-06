

# procedure to retrieve the data from the called id, and check if it matches the passed conditions of nepali date
DELIMITER //
CREATE PROCEDURE md_query(newid INT, isNepali BOOLEAN, dateLevel VARCHAR(50))
BEGIN
	DECLARE startdate DATE;
	DECLARE enddate DATE;
	--  select start date and end date for the given conditions 
	SELECT start_date, end_date INTO startdate, enddate FROM sw_001_extenso.md_date WHERE id=newid AND is_nepali= isNepali AND date_level=dateLevel;
	
    -- select the respective values
    -- create table date_md_table()
	SELECT trans.created_date, SUM(trans.amount), AVG(trans.amount), COUNT(trans.txn_id)
	FROM sw_001_extenso.rw_transaction_data AS trans 
	JOIN sw_001_extenso.product_category_map AS prod
	USING (module_id, product_id, product_type_id)
	WHERE trans.created_date BETWEEN startdate AND enddate
	-- 	and isNepali=true
	-- 	and dateLevel='M'
	GROUP BY trans.payer_account_id, trans.created_date;

END //
DELIMITER ;

CALL sw_001_extenso.md_query(6, FALSE, 'M');
SELECT * FROM sw_001_extenso.rw_transaction_data;
DROP PROCEDURE sw_001_extenso.md_query;



# pass the date to check from the mddate table if the passed date exists and satisfies the columns
DELIMITER //
CREATE PROCEDURE md_query_date(newdate DATE, isNepali BOOLEAN, dateLevel VARCHAR(50))
BEGIN
	DECLARE startdate DATE;
	DECLARE enddate DATE;
	--  select start date and end date for the given conditions 
	SELECT start_date, end_date INTO startdate, enddate FROM sw_001_extenso.md_date WHERE start_date=newdate AND is_nepali= isNepali AND date_level=dateLevel;
	
    -- select the respective values
    -- create table date_md_table()
	SELECT trans.created_date, SUM(trans.amount), AVG(trans.amount), COUNT(trans.txn_id)
	FROM sw_001_extenso.rw_transaction_data AS trans 
	JOIN sw_001_extenso.product_category_map AS prod
	USING (module_id, product_id, product_type_id)
	WHERE trans.created_date BETWEEN startdate AND enddate

	GROUP BY trans.payer_account_id, trans.created_date;

END //
DELIMITER ;

CALL sw_001_extenso.md_query_date('2023-05-14', TRUE, 'W');

SELECT * FROM sw_001_extenso.rw_transaction_data;
DROP PROCEDURE sw_001_extenso.md_query_date;


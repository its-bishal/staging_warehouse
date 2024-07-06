
 use data;
 
 -- create a copy of the existing table 
 create table data.partitioned_table like data.sample_data;
 insert into data.partitioned_table select * from data.sample_data;
 select * from data.partitioned_table;


 -- creating partitions in a table 
 alter table data.partitioned_table
 partition by range columns(start_date_time)(
	partition p0 values less than ('2024-06-01 00:00:01'), 
    partition p1 values less than ('2024-06-03 00:00:01'),
    partition p2 values less than ('2024-06-04 00:00:01'),
	partition p3 values less than ('2024-06-05 00:00:01'),
    partition p4 values less than ('2024-06-06 00:00:01')
 );
 
 
-- explains the partitions created into the table 
 explain select * from data.partitioned_table;

 
select * from `data`.sample_data where txn_date between '2024-06-01 00:00:00' and '2024-06-01 23:59:59';

select * from `data`.sample_data where txn_date between current_date and date_add(current_date, interval 1 day) - interval 1 second;
select * from `data`.sample_data;
        
DELIMITER $$

CREATE PROCEDURE data.EvaluateTransactions()
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE txn_date DATE;

    DECLARE cursor1 CURSOR FOR 
        SELECT DISTINCT DATE(txn_date) AS txn_date
        FROM `data`.sample_data
        WHERE txn_date BETWEEN '2024-06-01 00:00:00' AND '2024-06-30 23:59:59';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN cursor1;

    read_loop: LOOP
        FETCH cursor1 INTO txn_date;

        IF finished THEN
            LEAVE read_loop;
        END IF;

        -- Query to select transactions for the current date
        SELECT * FROM `data`.sample_data 
        WHERE txn_date BETWEEN txn_date AND DATE_ADD(txn_date, INTERVAL 1 DAY) - INTERVAL 1 SECOND;
        
        -- Process your data here if needed
    END LOOP;

    CLOSE cursor1;
END$$

DELIMITER ;


CALL EvaluateTransactions();


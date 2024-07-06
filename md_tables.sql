
# table to retrieve the weekly date time for a month and retrieve data for particular week
CREATE TABLE sw_001_extenso.md_weekly(
	id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATE,
    end_date DATE
);

INSERT INTO sw_001_extenso.md_weekly (start_date, end_date) VALUES('2023-04-30', '2023-05-06');
INSERT INTO sw_001_extenso.md_weekly (start_date, end_date) VALUES('2023-05-07', '2023-05-13');
INSERT INTO sw_001_extenso.md_weekly (start_date, end_date) VALUES('2023-05-14', '2023-05-20');
INSERT INTO sw_001_extenso.md_weekly (start_date, end_date) VALUES('2023-05-21', '2023-05-27');
INSERT INTO sw_001_extenso.md_weekly (start_date, end_date) VALUES('2023-05-28', '2023-06-03');

SELECT * FROM sw_001_extenso.md_weekly;


# table consisting of date intervals on the basis of either nepali or english calender
# also specifying the type of the interval i.e. weekly, monthly, so on

CREATE TABLE md_date(
	id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    is_nepali BOOLEAN,
    date_level VARCHAR(50)
);

SELECT * FROM sw_001_extenso.md_date;

INSERT INTO sw_001_extenso.md_date(start_date, end_date, is_nepali, date_level) VALUES ('2023-05-07', '2023-05-13', 1, 'W');
INSERT INTO sw_001_extenso.md_date(start_date, end_date, is_nepali, date_level) VALUES ('2023-05-07', '2023-05-13', 1, 'W');
INSERT INTO sw_001_extenso.md_date(start_date, end_date, is_nepali, date_level) VALUES ('2023-05-14', '2023-05-20', 1, 'W');
INSERT INTO sw_001_extenso.md_date(start_date, end_date, is_nepali, date_level) VALUES ('2023-04-14', '2023-05-14', 1, 'M');
INSERT INTO sw_001_extenso.md_date(start_date, end_date, is_nepali, date_level) VALUES ('2023-05-07', '2023-05-13', 0, 'M');
INSERT INTO sw_001_extenso.md_date(start_date, end_date, is_nepali, date_level) VALUES ('2023-05-14', '2023-05-20', 0, 'M');
-- TC-15 FR_01: error esperado 1062, duplicacion UNIQUE
USE hotel_management_test;
INSERT INTO guest(full_name,identification_number)
VALUES('Duplicated Person','1712345678');

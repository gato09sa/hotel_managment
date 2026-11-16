-- TC-13 NFR_05: error esperado 1048, NOT NULL
USE hotel_management_test;
INSERT INTO guest(full_name,identification_number) VALUES(NULL,'1788888888');

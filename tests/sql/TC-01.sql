-- TC-01 FR_01 registrar y actualizar huesped
USE hotel_management_test;
INSERT INTO guest(full_name,identification_number,phone,email)
VALUES('Diego Paredes','1798765432','0990001122','diego.paredes@example.com');
SELECT guest_id,full_name,phone FROM guest WHERE identification_number='1798765432';
UPDATE guest SET phone='0987776655' WHERE identification_number='1798765432';
SELECT IF((SELECT guest_id FROM guest WHERE identification_number='1798765432')=6 AND
 (SELECT phone FROM guest WHERE identification_number='1798765432')='0987776655',
 'PASS_TC_01','FAIL_TC_01');

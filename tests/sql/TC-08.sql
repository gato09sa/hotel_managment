-- TC-08 FR_08: precio historico desayuno permanece en 8.00
USE hotel_management_test;
INSERT INTO service_charge(reservation_id,service_id,service_date,quantity,unit_price)
VALUES(4,1,'2026-12-13',2,8.00);
SELECT service_id,quantity,unit_price,quantity*unit_price AS line_total
 FROM service_charge WHERE reservation_id=4;
UPDATE service SET standard_price=9.50 WHERE service_id=1;
SELECT s.standard_price,c.unit_price,c.quantity*c.unit_price AS line_total
FROM service s JOIN service_charge c ON c.service_id=s.service_id
WHERE c.reservation_id=4 AND s.service_id=1;
SELECT IF((SELECT standard_price FROM service WHERE service_id=1)=9.50 AND
 (SELECT unit_price FROM service_charge WHERE reservation_id=4 AND service_id=1)=8.00,
'PASS_TC_08','FAIL_TC_08');

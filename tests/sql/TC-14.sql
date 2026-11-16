-- TC-14 NFR_06: ampliar catalogos sin alterar reservas
USE hotel_management_test;
INSERT INTO room_type(name,capacity,base_nightly_rate) VALUES('Penthouse',6,300.00);
INSERT INTO service(name,description,standard_price) VALUES('Parking','Car parking',5.00);
SELECT name,capacity,base_nightly_rate FROM room_type WHERE name='Penthouse';
SELECT name,standard_price FROM service WHERE name='Parking';
SELECT IF((SELECT COUNT(*) FROM reservation)=7 AND
 (SELECT COUNT(*) FROM room_type WHERE name='Penthouse' AND capacity=6)=1 AND
 (SELECT COUNT(*) FROM service WHERE name='Parking' AND standard_price=5)=1,
'PASS_TC_14','FAIL_TC_14');

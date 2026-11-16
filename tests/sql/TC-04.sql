-- TC-04 FR_04 reservar 302 del 20 al 23 dic
USE hotel_management_test;
INSERT INTO reservation(guest_id,room_id,check_in_date,check_out_date,nightly_rate,status)
VALUES(5,6,'2026-12-20','2026-12-23',70.00,'booked');
SELECT reservation_id,guest_id,room_id,check_in_date,check_out_date,nightly_rate,status
FROM reservation WHERE reservation_id=5;
SELECT IF((SELECT COUNT(*) FROM reservation WHERE reservation_id=5 AND guest_id=5
 AND room_id=6 AND check_in_date='2026-12-20' AND check_out_date='2026-12-23'
 AND nightly_rate=70 AND status='booked')=1,'PASS_TC_04','FAIL_TC_04');

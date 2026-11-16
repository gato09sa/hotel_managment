-- TC-17 FR_04: error esperado 3819, salida > entrada
USE hotel_management_test;
INSERT INTO reservation(guest_id,room_id,check_in_date,check_out_date,nightly_rate,status)
VALUES(5,1,'2026-12-25','2026-12-25',45.00,'booked');

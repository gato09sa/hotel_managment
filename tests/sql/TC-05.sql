-- TC-05 FR_05: demuestra consulta de deteccion Y la limitacion del esquema.
-- IMPORTANTE: las inserciones directas intencionalmente crean datos conflictivos SOLO en la BD de prueba.
USE hotel_management_test;
SELECT reservation_id,check_in_date,check_out_date,status FROM reservation
WHERE room_id=4 AND status IN('booked','checked_in')
 AND check_in_date<'2026-12-16' AND check_out_date>'2026-12-14';
INSERT INTO reservation(guest_id,room_id,check_in_date,check_out_date,nightly_rate,status)
VALUES (1,4,'2026-12-14','2026-12-16',120.00,'booked');
INSERT INTO reservation(guest_id,room_id,check_in_date,check_out_date,nightly_rate,status)
VALUES (1,4,'2026-12-15','2026-12-17',120.00,'booked');
SELECT IF((SELECT COUNT(*) FROM reservation WHERE room_id=4)=3
 AND (SELECT COUNT(*) FROM reservation WHERE reservation_id IN(6,7))=2,
 'PASS_TC_05_LIMITATION_DOCUMENTED','FAIL_TC_05');

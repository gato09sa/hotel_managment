-- TC-11 NFR_01: consulta simple; mide tiempo el cliente, NO prueba concurrencia/escala
USE hotel_management_test;
SELECT r.room_number FROM room r JOIN room_type t ON t.room_type_id=r.room_type_id
WHERE r.status='available' AND t.capacity>=2
AND NOT EXISTS(SELECT 1 FROM reservation x WHERE x.room_id=r.room_id
 AND x.status IN('booked','checked_in')
 AND x.check_in_date<'2026-12-13' AND x.check_out_date>'2026-12-11');
SELECT 'SMOKE_TC_11_PERFORMANCE_NOT_FULLY_VALIDATED';

-- TC-03 FR_03 disponibilidad 11-13 dic, capacidad >=2
USE hotel_management_test;
SELECT r.room_number,t.capacity,r.status FROM room r JOIN room_type t USING(room_type_id)
WHERE r.status='available' AND t.capacity>=2
AND NOT EXISTS (SELECT 1 FROM reservation x WHERE x.room_id=r.room_id
 AND x.status IN ('booked','checked_in')
 AND x.check_in_date<'2026-12-13' AND x.check_out_date>'2026-12-11')
ORDER BY r.room_number;
SELECT IF((SELECT GROUP_CONCAT(r.room_number ORDER BY r.room_number SEPARATOR ',')
FROM room r JOIN room_type t USING(room_type_id)
WHERE r.status='available' AND t.capacity>=2
AND NOT EXISTS(SELECT 1 FROM reservation x WHERE x.room_id=r.room_id
 AND x.status IN('booked','checked_in')
 AND x.check_in_date<'2026-12-13' AND x.check_out_date>'2026-12-11'))='102,302,401',
'PASS_TC_03','FAIL_TC_03');

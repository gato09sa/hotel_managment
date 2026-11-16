-- TC-10 FR_10: por huesped, fecha, habitacion, status
USE hotel_management_test;
SELECT reservation_id FROM reservation WHERE guest_id=(SELECT guest_id FROM guest WHERE identification_number='1712345678') ORDER BY reservation_id;
SELECT reservation_id FROM reservation WHERE '2026-12-13'>=check_in_date AND '2026-12-13'<check_out_date ORDER BY reservation_id;
SELECT reservation_id FROM reservation WHERE room_id=4 ORDER BY reservation_id;
SELECT reservation_id FROM reservation WHERE status='cancelled' ORDER BY reservation_id;
SELECT IF((SELECT GROUP_CONCAT(reservation_id ORDER BY reservation_id) FROM reservation WHERE guest_id=1)='1,6,7'
 AND (SELECT GROUP_CONCAT(reservation_id ORDER BY reservation_id) FROM reservation WHERE check_in_date<='2026-12-13' AND check_out_date>'2026-12-13')='2,4'
 AND (SELECT GROUP_CONCAT(reservation_id ORDER BY reservation_id) FROM reservation WHERE room_id=4)='2,6,7'
 AND (SELECT GROUP_CONCAT(reservation_id ORDER BY reservation_id) FROM reservation WHERE status='cancelled')='3,5',
 'PASS_TC_10','FAIL_TC_10');

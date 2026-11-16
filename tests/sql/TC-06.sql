-- TC-06 FR_06: checked_in, checked_out, cancelacion
USE hotel_management_test;
UPDATE reservation SET status='checked_in',actual_check_in_date='2026-12-10'
 WHERE reservation_id=2;
SELECT reservation_id,status,actual_check_in_date FROM reservation WHERE reservation_id=2;
UPDATE reservation SET status='checked_out',actual_check_out_date='2026-12-14'
 WHERE reservation_id=2;
UPDATE reservation SET status='cancelled' WHERE reservation_id=5;
SELECT reservation_id,status,actual_check_in_date,actual_check_out_date
 FROM reservation WHERE reservation_id IN(2,5);
SELECT IF((SELECT COUNT(*) FROM reservation WHERE reservation_id=2 AND status='checked_out'
 AND actual_check_in_date='2026-12-10' AND actual_check_out_date='2026-12-14')=1
 AND (SELECT status FROM reservation WHERE reservation_id=5)='cancelled',
 'PASS_TC_06','FAIL_TC_06');

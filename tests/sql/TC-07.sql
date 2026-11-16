-- TC-07 FR_07: dos pagos reserva 4 (75+100)
USE hotel_management_test;
INSERT INTO payment(reservation_id,amount,payment_date,payment_method,status)
VALUES(4,75.00,'2026-12-12','cash','completed'),
(4,100.00,'2026-12-14','debit_card','completed');
SELECT payment_id,amount,payment_date,payment_method,status
FROM payment WHERE reservation_id=4;
SELECT IF((SELECT COUNT(*) FROM payment WHERE reservation_id=4 AND status='completed')=2
 AND (SELECT SUM(amount) FROM payment WHERE reservation_id=4 AND status='completed')=175.00,
'PASS_TC_07','FAIL_TC_07');

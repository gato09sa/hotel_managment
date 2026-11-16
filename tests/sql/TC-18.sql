-- TC-18 FR_07: error esperado 3819, pago > 0
USE hotel_management_test;
INSERT INTO payment(reservation_id,amount,payment_date,payment_method,status)
VALUES(4,-10.00,'2026-12-14','cash','completed');

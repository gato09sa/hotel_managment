-- TC-12 NFR_03: EJECUTAR antes y despues del reinicio manual del contenedor.
USE hotel_management_test;
SELECT 'guest' AS name,COUNT(*) AS rows_total FROM guest
UNION ALL SELECT 'room',COUNT(*) FROM room
UNION ALL SELECT 'reservation',COUNT(*) FROM reservation
UNION ALL SELECT 'payment',COUNT(*) FROM payment;
SELECT IF((SELECT COUNT(*) FROM guest)=6 AND (SELECT COUNT(*) FROM room)=7
 AND (SELECT COUNT(*) FROM reservation)=7 AND (SELECT COUNT(*) FROM payment)=5,
'CHECK_TC_12_COUNTS_OK','CHECK_TC_12_COUNTS_DIFFER');

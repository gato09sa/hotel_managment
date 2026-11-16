-- TC-09 FR_09: cargo 140 + servicios 51 - pagos 175 = saldo 16
USE hotel_management_test;
SELECT r.reservation_id,DATEDIFF(r.check_out_date,r.check_in_date)*r.nightly_rate AS room_charge,
 (SELECT SUM(c.quantity*c.unit_price) FROM service_charge c WHERE c.reservation_id=r.reservation_id) AS service_total,
 (SELECT SUM(p.amount) FROM payment p WHERE p.reservation_id=r.reservation_id AND p.status='completed') AS paid_total
FROM reservation r WHERE r.reservation_id=4;
SELECT IF((SELECT DATEDIFF(check_out_date,check_in_date)*nightly_rate
 FROM reservation WHERE reservation_id=4)=140.00 AND
 (SELECT SUM(quantity*unit_price) FROM service_charge WHERE reservation_id=4)=51.00 AND
 (SELECT SUM(amount) FROM payment WHERE reservation_id=4 AND status='completed')=175.00,
'PASS_TC_09','FAIL_TC_09');

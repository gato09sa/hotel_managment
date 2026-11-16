-- Consultas de negocio ilustrativas reconstruidas de la especificacion.
USE hotel_management;
-- Verificar posibles conflictos: habitacion 202 del 14 al 16 de diciembre.
SELECT reservation_id, check_in_date, check_out_date, status
FROM reservation WHERE room_id = 4
 AND status IN ('booked','checked_in')
 AND check_in_date < '2026-12-16'
 AND check_out_date > '2026-12-14';
-- Habitaciones con capacidad >=2 libres del 11 al 13 de diciembre.
SELECT r.room_number, t.name, t.capacity, t.base_nightly_rate
FROM room r JOIN room_type t ON t.room_type_id = r.room_type_id
WHERE r.status = 'available' AND t.capacity >= 2
AND NOT EXISTS (
  SELECT 1 FROM reservation x WHERE x.room_id = r.room_id
   AND x.status IN ('booked','checked_in')
   AND x.check_in_date < '2026-12-13'
   AND x.check_out_date > '2026-12-11'
) ORDER BY r.room_number;
-- Cargos y pagos de la reserva 4 (ejecutar despues del TC-08).
SELECT DATEDIFF(check_out_date,check_in_date)*nightly_rate AS room_charge
FROM reservation WHERE reservation_id=4;
SELECT COALESCE(SUM(quantity*unit_price),0) AS service_total
FROM service_charge WHERE reservation_id=4;
SELECT COALESCE(SUM(amount),0) AS paid_total
FROM payment WHERE reservation_id=4 AND status='completed';

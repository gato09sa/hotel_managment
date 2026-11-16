-- Datos ficticios RECONSTRUIDOS para obtener los resultados del PDF; no son
-- necesariamente identicos a los inserts originales de Stage 2.
USE hotel_management;
INSERT INTO guest (full_name, identification_number, phone, email) VALUES
('Ana Torres','1712345678','0991111111','ana@example.test'),
('Luis Herrera','1722222222','0992222222','luis@example.test'),
('Maria Gomez','1733333333','0993333333','maria@example.test'),
('Carlos Ruiz','1744444444','0994444444','carlos@example.test'),
('Elena Castro','1755555555','0995555555','elena@example.test');
INSERT INTO room_type (name,capacity,base_nightly_rate) VALUES
('Single',1,45.00),('Double',2,70.00),('Suite',4,120.00);
INSERT INTO room (room_type_id,room_number,floor,status) VALUES
(1,'101',1,'available'),(2,'102',1,'available'),
(2,'201',2,'available'),(3,'202',2,'available'),
(3,'301',3,'out_of_service'),(2,'302',3,'available');
INSERT INTO reservation (guest_id,room_id,check_in_date,check_out_date,nightly_rate,status) VALUES
(1,1,'2026-12-04','2026-12-06',45.00,'booked'),
(2,4,'2026-12-10','2026-12-15',120.00,'booked'),
(3,2,'2026-12-05','2026-12-07',70.00,'cancelled'),
(4,3,'2026-12-12','2026-12-14',70.00,'checked_in');
INSERT INTO payment (reservation_id,amount,payment_date,payment_method,status) VALUES
(1,80.00,'2026-12-04','cash','completed'),
(2,100.00,'2026-12-10','bank_transfer','completed'),
(3,40.00,'2026-12-05','credit_card','refunded');
INSERT INTO service (name,description,standard_price) VALUES
('Breakfast','Breakfast buffet',8.00),('Spa session','Spa access',35.00),
('Laundry','Laundry service',12.00);
INSERT INTO service_charge (reservation_id,service_id,service_date,quantity,unit_price)
VALUES (4,2,'2026-12-12',1,35.00);

-- TC-16 FR_02: error esperado 3819, capacity > 0
USE hotel_management_test;
INSERT INTO room_type(name,capacity,base_nightly_rate)
VALUES('Broken',0,50.00);

-- TC-02 FR_02 crear tipo Family y habitacion 401
USE hotel_management_test;
INSERT INTO room_type(name,capacity,base_nightly_rate) VALUES('Family',5,150.00);
INSERT INTO room(room_type_id,room_number,floor,status)
SELECT room_type_id,'401',4,'available' FROM room_type WHERE name='Family';
SELECT r.room_number,t.name,t.capacity,t.base_nightly_rate,r.status
FROM room r JOIN room_type t ON r.room_type_id=t.room_type_id WHERE r.room_number='401';
SELECT IF((SELECT COUNT(*) FROM room r JOIN room_type t ON r.room_type_id=t.room_type_id
 WHERE r.room_number='401' AND t.name='Family' AND t.capacity=5
 AND t.base_nightly_rate=150 AND r.status='available')=1,'PASS_TC_02','FAIL_TC_02');

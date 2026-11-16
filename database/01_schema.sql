-- Recreacion verificable del esquema del documento pj2.pdf, NO el script original.
CREATE DATABASE IF NOT EXISTS hotel_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_management;
CREATE TABLE guest (
  guest_id INT NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  identification_number VARCHAR(30) NOT NULL,
  phone VARCHAR(20) NULL,
  email VARCHAR(100) NULL,
  CONSTRAINT pk_guest PRIMARY KEY (guest_id),
  CONSTRAINT uq_guest_identification_number UNIQUE (identification_number),
  CONSTRAINT uq_guest_email UNIQUE (email)
) ENGINE=InnoDB;
CREATE TABLE room_type (
  room_type_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  capacity INT NOT NULL,
  base_nightly_rate DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_room_type PRIMARY KEY (room_type_id),
  CONSTRAINT uq_room_type_name UNIQUE (name),
  CONSTRAINT ck_room_type_capacity_positive CHECK (capacity > 0),
  CONSTRAINT ck_room_type_rate_not_negative CHECK (base_nightly_rate >= 0)
) ENGINE=InnoDB;
CREATE TABLE room (
  room_id INT NOT NULL AUTO_INCREMENT,
  room_type_id INT NOT NULL,
  room_number VARCHAR(10) NOT NULL,
  floor INT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'available',
  CONSTRAINT pk_room PRIMARY KEY (room_id),
  CONSTRAINT uq_room_room_number UNIQUE (room_number),
  CONSTRAINT ck_room_status_valid CHECK (status IN ('available','maintenance','out_of_service')),
  CONSTRAINT fk_room_room_type FOREIGN KEY (room_type_id) REFERENCES room_type(room_type_id)
     ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
CREATE TABLE reservation (
  reservation_id INT NOT NULL AUTO_INCREMENT,
  guest_id INT NOT NULL,
  room_id INT NOT NULL,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  nightly_rate DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'booked',
  actual_check_in_date DATE NULL,
  actual_check_out_date DATE NULL,
  CONSTRAINT pk_reservation PRIMARY KEY (reservation_id),
  CONSTRAINT ck_reservation_dates_ordered CHECK (check_out_date > check_in_date),
  CONSTRAINT ck_reservation_actual_dates_ordered CHECK (
    actual_check_out_date IS NULL OR
    (actual_check_in_date IS NOT NULL AND actual_check_out_date >= actual_check_in_date)),
  CONSTRAINT ck_reservation_rate_not_negative CHECK (nightly_rate >= 0),
  CONSTRAINT ck_reservation_status_valid CHECK (status IN ('booked','checked_in','checked_out','cancelled')),
  CONSTRAINT fk_reservation_guest FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
     ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_reservation_room FOREIGN KEY (room_id) REFERENCES room(room_id)
     ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_reservation_room_id_dates (room_id, check_in_date, check_out_date),
  INDEX idx_reservation_guest_id (guest_id),
  INDEX idx_reservation_status (status),
  INDEX idx_reservation_check_in_date (check_in_date)
) ENGINE=InnoDB;
CREATE TABLE payment (
  payment_id INT NOT NULL AUTO_INCREMENT,
  reservation_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_date DATE NOT NULL,
  payment_method VARCHAR(30) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'completed',
  CONSTRAINT pk_payment PRIMARY KEY (payment_id),
  CONSTRAINT ck_payment_amount_positive CHECK (amount > 0),
  CONSTRAINT ck_payment_method_valid CHECK (payment_method IN ('cash','credit_card','debit_card','bank_transfer')),
  CONSTRAINT ck_payment_status_valid CHECK (status IN ('pending','completed','refunded')),
  CONSTRAINT fk_payment_reservation FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id)
     ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_payment_reservation_id (reservation_id)
) ENGINE=InnoDB;
CREATE TABLE service (
  service_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255) NULL,
  standard_price DECIMAL(10,2) NOT NULL,
  availability_status VARCHAR(20) NOT NULL DEFAULT 'available',
  CONSTRAINT pk_service PRIMARY KEY (service_id),
  CONSTRAINT uq_service_name UNIQUE (name),
  CONSTRAINT ck_service_price_not_negative CHECK (standard_price >= 0),
  CONSTRAINT ck_service_availability_valid CHECK (availability_status IN ('available','unavailable'))
) ENGINE=InnoDB;
CREATE TABLE service_charge (
  service_charge_id INT NOT NULL AUTO_INCREMENT,
  reservation_id INT NOT NULL,
  service_id INT NOT NULL,
  service_date DATE NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_service_charge PRIMARY KEY (service_charge_id),
  CONSTRAINT ck_service_charge_quantity_positive CHECK (quantity > 0),
  CONSTRAINT ck_service_charge_price_not_negative CHECK (unit_price >= 0),
  CONSTRAINT fk_service_charge_reservation FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id)
     ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_service_charge_service FOREIGN KEY (service_id) REFERENCES service(service_id)
     ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_service_charge_reservation_id (reservation_id)
) ENGINE=InnoDB;



CREATE DATABASE IF NOT EXISTS BBMS;
USE BBMS;

-- Admin Table
CREATE TABLE admin (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  pwd VARCHAR(255) NOT NULL
);

-- Blood Inventory Table
CREATE TABLE blood (
   id INT AUTO_INCREMENT PRIMARY KEY,
   AP INT DEFAULT 0,
   AN INT DEFAULT 0,
   BP INT DEFAULT 0,
   BN INT DEFAULT 0,
   ABP INT DEFAULT 0,
   ABN INT DEFAULT 0,
   OP INT DEFAULT 0,
   `ON` INT DEFAULT 0
);


-- Donor Table
CREATE TABLE donor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  pwd VARCHAR(255) NOT NULL,
  blood VARCHAR(10) NOT NULL
);

-- Patient Table
CREATE TABLE patient (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  pwd VARCHAR(255) NOT NULL,
  blood VARCHAR(10) NOT NULL
);

-- Donate History Table
CREATE TABLE donate (
  id INT AUTO_INCREMENT PRIMARY KEY,
  donor_id INT NOT NULL,
  username VARCHAR(255) NOT NULL,
  disease VARCHAR(255) NOT NULL,
  blood VARCHAR(10) NOT NULL,
  unit INT NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  FOREIGN KEY (donor_id) REFERENCES donor(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Blood Request Table
CREATE TABLE request (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  username VARCHAR(255) NOT NULL,
  reason VARCHAR(255) NOT NULL,
  blood VARCHAR(10) NOT NULL,
  unit INT NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Sample Admin
INSERT INTO admin (name, username, email, pwd) VALUES
('Mubashir Ali', 'mubashir', 'mubashir@example.com', '123'),
('Tayyab mehmood', 'tayyab', 'tayyab@example.com', '123');

-- Sample Blood Inventory (initial stock)
INSERT INTO blood (AP, AN, BP, BN, ABP, ABN, OP,`ON`) VALUES
(5, 3, 4, 2, 6, 2, 7, 3);

-- Sample Donor
INSERT INTO donor (name, username, email, pwd, blood) VALUES
('Ali Khan', 'alikhan', 'ali@example.com', '$2y$10$someHashedPasswordHere', 'B+');

-- Sample Patient
INSERT INTO patient (name, username, email, pwd, blood) VALUES
('Sara Ahmed', 'sara123', 'sara@example.com', '$2y$10$anotherHashedPasswordHere', 'A+');

-- Sample Donation Record
INSERT INTO donate (donor_id, username, disease, blood, unit, status) VALUES
(1, 'alikhan', 'none', 'B+', 1, 'approved');

-- Sample Blood Request
INSERT INTO request (patient_id, username, reason, blood, unit, status) VALUES
(1, 'sara123', 'surgery', 'A+', 2, 'pending');






-- Triggers

DELIMITER //
CREATE TRIGGER update_blood_after_donation
AFTER INSERT ON donate
FOR EACH ROW
BEGIN
  IF NEW.status = 'approved' THEN
    UPDATE blood
    SET 
      AP = AP + IF(NEW.blood = 'A+', NEW.unit, 0),
      AN = AN + IF(NEW.blood = 'A-', NEW.unit, 0),
      BP = BP + IF(NEW.blood = 'B+', NEW.unit, 0),
      BN = BN + IF(NEW.blood = 'B-', NEW.unit, 0),
      ABP = ABP + IF(NEW.blood = 'AB+', NEW.unit, 0),
      ABN = ABN + IF(NEW.blood = 'AB-', NEW.unit, 0),
      OP = OP + IF(NEW.blood = 'O+', NEW.unit, 0),
      `ON` = `ON` + IF(NEW.blood = 'O-', NEW.unit, 0);
  END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER update_blood_after_request_approval
AFTER UPDATE ON request
FOR EACH ROW
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE blood
    SET 
      AP = AP - IF(NEW.blood = 'A+', NEW.unit, 0),
      AN = AN - IF(NEW.blood = 'A-', NEW.unit, 0),
      BP = BP - IF(NEW.blood = 'B+', NEW.unit, 0),
      BN = BN - IF(NEW.blood = 'B-', NEW.unit, 0),
      ABP = ABP - IF(NEW.blood = 'AB+', NEW.unit, 0),
      ABN = ABN - IF(NEW.blood = 'AB-', NEW.unit, 0),
      OP = OP - IF(NEW.blood = 'O+', NEW.unit, 0),
      `ON` = `ON` - IF(NEW.blood = 'O-', NEW.unit, 0);
  END IF;
END;
//
DELIMITER ;



--  procedures
DELIMITER //
CREATE PROCEDURE register_donor(
  IN p_name VARCHAR(255),
  IN p_username VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_pwd VARCHAR(255),
  IN p_blood VARCHAR(10)
)
BEGIN
  INSERT INTO donor (name, username, email, pwd, blood)
  VALUES (p_name, p_username, p_email, p_pwd, p_blood);
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE request_blood(
  IN p_patient_id INT,
  IN p_username VARCHAR(255),
  IN p_reason VARCHAR(255),
  IN p_blood VARCHAR(10),
  IN p_unit INT
)
BEGIN
  INSERT INTO request (patient_id, username, reason, blood, unit)
  VALUES (p_patient_id, p_username, p_reason, p_blood, p_unit);
END;
//
DELIMITER ;


-- function
DELIMITER //
CREATE FUNCTION get_total_units(blood_type VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT
    CASE blood_type
      WHEN 'A+' THEN AP
      WHEN 'A-' THEN AN
      WHEN 'B+' THEN BP
      WHEN 'B-' THEN BN
      WHEN 'AB+' THEN ABP
      WHEN 'AB-' THEN ABN
      WHEN 'O+' THEN OP
      WHEN 'O-' THEN `ON`
      ELSE 0
    END INTO total
  FROM blood
  LIMIT 1;
  RETURN total;
END;
//
DELIMITER ;




-- joins

SELECT p.name, p.blood, r.unit, r.status
FROM patient p
JOIN request r ON p.id = r.patient_id;


SELECT d.name, d.blood, dn.unit, dn.status
FROM donor d
JOIN donate dn ON d.id = dn.donor_id;

SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET time_zone = '+00:00';

CREATE DATABASE IF NOT EXISTS `schooldb`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `schooldb`;

SET FOREIGN_KEY_CHECKS = 0;

DROP VIEW IF EXISTS `vw_applicant_summary`;
DROP VIEW IF EXISTS `vw_application_requirements`;

DROP TABLE IF EXISTS `notification`;
DROP TABLE IF EXISTS `requirement`;
DROP TABLE IF EXISTS `curriculum_requirement`;
DROP TABLE IF EXISTS `application`;
DROP TABLE IF EXISTS `previous_education`;
DROP TABLE IF EXISTS `applicant_emergency_contact`;
DROP TABLE IF EXISTS `applicant`;
DROP TABLE IF EXISTS `deadline`;
DROP TABLE IF EXISTS `tracking_sequences`;
DROP TABLE IF EXISTS `rejection_reason`;
DROP TABLE IF EXISTS `requirement_type`;
DROP TABLE IF EXISTS `requirement_status`;
DROP TABLE IF EXISTS `application_status`;
DROP TABLE IF EXISTS `educational_background_category`;
DROP TABLE IF EXISTS `program`;
DROP TABLE IF EXISTS `campus`;
DROP TABLE IF EXISTS `user_activity_log`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `role`;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- 1. Reference tables
-- ============================================================================

CREATE TABLE `role` (
  `role_id` INT NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(50) NOT NULL,
  `role_description` TEXT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uq_role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `role_id` INT NOT NULL,
  `username` VARCHAR(60) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_user_username` (`username`),
  UNIQUE KEY `uq_user_email` (`email`),
  KEY `idx_user_role_id` (`role_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`)
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `campus` (
  `campus_id` INT NOT NULL AUTO_INCREMENT,
  `campus_name` VARCHAR(150) NOT NULL,
  `campus_location` VARCHAR(255) NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`campus_id`),
  UNIQUE KEY `uq_campus_name_location` (`campus_name`, `campus_location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `program` (
  `program_id` INT NOT NULL AUTO_INCREMENT,
  `program_code` VARCHAR(20) NOT NULL,
  `program_name` VARCHAR(255) NOT NULL,
  `program_is_active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`program_id`),
  UNIQUE KEY `uq_program_code` (`program_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `educational_background_category` (
  `educational_background_category_id` INT NOT NULL AUTO_INCREMENT,
  `educational_background_category_name` VARCHAR(100) NOT NULL,
  `educational_background_category_code` VARCHAR(20) NOT NULL,
  `educational_background_category_description` TEXT NULL,
  `educational_background_category_is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `educational_background_category_created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`educational_background_category_id`),
  UNIQUE KEY `uq_educational_background_category_code` (`educational_background_category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `application_status` (
  `application_status_id` INT NOT NULL AUTO_INCREMENT,
  `application_status_name` VARCHAR(50) NOT NULL,
  `application_status_description` TEXT NULL,
  `application_status_color` VARCHAR(20) NOT NULL DEFAULT 'gray',
  `application_status_is_final` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`application_status_id`),
  UNIQUE KEY `uq_application_status_name` (`application_status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `requirement_status` (
  `requirement_status_id` INT NOT NULL AUTO_INCREMENT,
  `requirement_status_name` VARCHAR(50) NOT NULL,
  `requirement_status_description` TEXT NULL,
  `requirement_status_color` VARCHAR(20) NOT NULL DEFAULT 'gray',
  `requirement_status_is_final` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`requirement_status_id`),
  UNIQUE KEY `uq_requirement_status_name` (`requirement_status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `requirement_type` (
  `requirement_type_id` INT NOT NULL AUTO_INCREMENT,
  `requirement_type_name` VARCHAR(150) NOT NULL,
  `requirement_type_description` TEXT NULL,
  PRIMARY KEY (`requirement_type_id`),
  UNIQUE KEY `uq_requirement_type_name` (`requirement_type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `rejection_reason` (
  `rejection_reason_id` INT NOT NULL AUTO_INCREMENT,
  `rejection_reason_name` VARCHAR(150) NOT NULL,
  `rejection_reason_description` TEXT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`rejection_reason_id`),
  UNIQUE KEY `uq_rejection_reason_name` (`rejection_reason_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tracking_sequences` (
  `tracking_sequences_id` INT NOT NULL AUTO_INCREMENT,
  `entity_type` ENUM('APPLICATION','REQUIREMENT') NOT NULL,
  `prefix` VARCHAR(10) NOT NULL,
  `last_sequence` INT NOT NULL DEFAULT 0,
  `current_year` YEAR NOT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tracking_sequences_id`),
  UNIQUE KEY `uq_tracking_entity_year` (`entity_type`, `current_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `deadline` (
  `deadline_id` INT NOT NULL AUTO_INCREMENT,
  `requirement_type_id` INT NULL,
  `deadline_name` VARCHAR(150) NOT NULL,
  `deadline_date` DATE NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`deadline_id`),
  KEY `idx_deadline_requirement_type_id` (`requirement_type_id`),
  CONSTRAINT `fk_deadline_requirement_type` FOREIGN KEY (`requirement_type_id`) REFERENCES `requirement_type` (`requirement_type_id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 2. Applicant records
-- ============================================================================

CREATE TABLE `applicant` (
  `applicant_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) NULL,
  `sex` ENUM('Male','Female') NOT NULL,
  `civil_status` ENUM('Single','Married','Widowed','Separated') NULL,
  `birth_date` DATE NULL,
  `email` VARCHAR(150) NULL,
  `phone` VARCHAR(30) NULL,
  `address` TEXT NULL,
  `campus_id` INT NOT NULL,
  `educational_background_category_id` INT NOT NULL,
  `created_by_user_id` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`applicant_id`),
  KEY `idx_applicant_name` (`last_name`, `first_name`),
  KEY `idx_applicant_email` (`email`),
  KEY `idx_applicant_campus_id` (`campus_id`),
  KEY `idx_applicant_educational_background_category_id` (`educational_background_category_id`),
  KEY `idx_applicant_created_by_user_id` (`created_by_user_id`),
  CONSTRAINT `fk_applicant_campus` FOREIGN KEY (`campus_id`) REFERENCES `campus` (`campus_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_applicant_educational_background_category` FOREIGN KEY (`educational_background_category_id`) REFERENCES `educational_background_category` (`educational_background_category_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_applicant_created_by_user` FOREIGN KEY (`created_by_user_id`) REFERENCES `user` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `applicant_emergency_contact` (
  `applicant_emergency_contact_id` INT NOT NULL AUTO_INCREMENT,
  `applicant_id` INT NOT NULL,
  `contact_name` VARCHAR(150) NOT NULL,
  `relationship` VARCHAR(100) NULL,
  `contact_number` VARCHAR(50) NULL,
  `address` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`applicant_emergency_contact_id`),
  KEY `idx_emergency_contact_applicant_id` (`applicant_id`),
  CONSTRAINT `fk_emergency_contact_applicant` FOREIGN KEY (`applicant_id`) REFERENCES `applicant` (`applicant_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `previous_education` (
  `previous_education_id` INT NOT NULL AUTO_INCREMENT,
  `applicant_id` INT NOT NULL,
  `educational_background_category_id` INT NOT NULL,
  `mode_of_learning` ENUM('Online','Face-to-face','Modular','Blended') NULL,
  `last_school_name` VARCHAR(200) NOT NULL,
  `school_address` TEXT NULL,
  `year_graduated` YEAR NULL,
  `units_earned` DECIMAL(5,1) NULL,
  `last_course` VARCHAR(150) NULL,
  `exam_center` VARCHAR(200) NULL,
  `track` VARCHAR(100) NULL,
  `strand` VARCHAR(100) NULL,
  `year_passed` YEAR NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`previous_education_id`),
  KEY `idx_previous_education_applicant_id` (`applicant_id`),
  KEY `idx_previous_education_category_id` (`educational_background_category_id`),
  CONSTRAINT `fk_previous_education_applicant` FOREIGN KEY (`applicant_id`) REFERENCES `applicant` (`applicant_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_previous_education_category` FOREIGN KEY (`educational_background_category_id`) REFERENCES `educational_background_category` (`educational_background_category_id`)
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 3. Application and document tracking
-- ============================================================================

CREATE TABLE `application` (
  `application_id` INT NOT NULL AUTO_INCREMENT,
  `applicant_id` INT NOT NULL,
  `program_id` INT NOT NULL,
  `campus_id` INT NOT NULL,
  `application_status_id` INT NOT NULL,
  `submission_method` ENUM('Personal','Courier','Online') NOT NULL DEFAULT 'Personal',
  `tracking_no` VARCHAR(40) NULL,
  `application_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `academic_year` VARCHAR(20) NULL,
  `semester` VARCHAR(30) NULL,
  `remarks` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `uq_application_tracking_no` (`tracking_no`),
  KEY `idx_application_applicant_id` (`applicant_id`),
  KEY `idx_application_program_id` (`program_id`),
  KEY `idx_application_campus_id` (`campus_id`),
  KEY `idx_application_status_id` (`application_status_id`),
  CONSTRAINT `fk_application_applicant` FOREIGN KEY (`applicant_id`) REFERENCES `applicant` (`applicant_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_application_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_application_campus` FOREIGN KEY (`campus_id`) REFERENCES `campus` (`campus_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_application_status` FOREIGN KEY (`application_status_id`) REFERENCES `application_status` (`application_status_id`)
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `curriculum_requirement` (
  `curriculum_requirement_id` INT NOT NULL AUTO_INCREMENT,
  `educational_background_category_id` INT NOT NULL,
  `requirement_type_id` INT NOT NULL,
  `is_mandatory` TINYINT(1) NOT NULL DEFAULT 1,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`curriculum_requirement_id`),
  UNIQUE KEY `uq_curriculum_requirement` (`educational_background_category_id`, `requirement_type_id`),
  KEY `idx_curriculum_requirement_type_id` (`requirement_type_id`),
  CONSTRAINT `fk_curriculum_requirement_category` FOREIGN KEY (`educational_background_category_id`) REFERENCES `educational_background_category` (`educational_background_category_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_curriculum_requirement_type` FOREIGN KEY (`requirement_type_id`) REFERENCES `requirement_type` (`requirement_type_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `requirement` (
  `requirement_id` INT NOT NULL AUTO_INCREMENT,
  `application_id` INT NOT NULL,
  `requirement_type_id` INT NOT NULL,
  `requirement_status_id` INT NOT NULL,
  `file_name` VARCHAR(255) NULL,
  `file_path` VARCHAR(255) NULL,
  `remarks` TEXT NULL,
  `uploaded_by_user_id` INT NULL,
  `processed_by_user_id` INT NULL,
  `rejection_reason_id` INT NULL,
  `submitted_at` DATETIME NULL,
  `processed_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`requirement_id`),
  UNIQUE KEY `uq_requirement_application_type` (`application_id`, `requirement_type_id`),
  KEY `idx_requirement_type_id` (`requirement_type_id`),
  KEY `idx_requirement_status_id` (`requirement_status_id`),
  KEY `idx_requirement_uploaded_by_user_id` (`uploaded_by_user_id`),
  KEY `idx_requirement_processed_by_user_id` (`processed_by_user_id`),
  KEY `idx_requirement_rejection_reason_id` (`rejection_reason_id`),
  CONSTRAINT `fk_requirement_application` FOREIGN KEY (`application_id`) REFERENCES `application` (`application_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_requirement_type` FOREIGN KEY (`requirement_type_id`) REFERENCES `requirement_type` (`requirement_type_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_requirement_status` FOREIGN KEY (`requirement_status_id`) REFERENCES `requirement_status` (`requirement_status_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_requirement_uploaded_by_user` FOREIGN KEY (`uploaded_by_user_id`) REFERENCES `user` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_requirement_processed_by_user` FOREIGN KEY (`processed_by_user_id`) REFERENCES `user` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_requirement_rejection_reason` FOREIGN KEY (`rejection_reason_id`) REFERENCES `rejection_reason` (`rejection_reason_id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `notification` (
  `notification_id` INT NOT NULL AUTO_INCREMENT,
  `requirement_id` INT NULL,
  `applicant_id` INT NULL,
  `message` TEXT NOT NULL,
  `notification_type` ENUM('Missing Requirement','Overdue Deadline','Status Update','General') NOT NULL DEFAULT 'General',
  `date_sent` DATETIME NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `created_by_user_id` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notification_requirement_id` (`requirement_id`),
  KEY `idx_notification_applicant_id` (`applicant_id`),
  KEY `idx_notification_created_by_user_id` (`created_by_user_id`),
  CONSTRAINT `fk_notification_requirement` FOREIGN KEY (`requirement_id`) REFERENCES `requirement` (`requirement_id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_applicant` FOREIGN KEY (`applicant_id`) REFERENCES `applicant` (`applicant_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_created_by_user` FOREIGN KEY (`created_by_user_id`) REFERENCES `user` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_activity_log` (
  `user_activity_log_id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `action_type` VARCHAR(100) NOT NULL,
  `entity_type` VARCHAR(100) NOT NULL,
  `entity_id` INT NULL,
  `description` TEXT NULL,
  `performed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_activity_log_id`),
  KEY `idx_activity_user_id` (`user_id`),
  CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 4. Helpful reporting views
-- ============================================================================

CREATE VIEW `vw_applicant_summary` AS
SELECT
  a.applicant_id,
  CONCAT(a.first_name, ' ', IFNULL(CONCAT(a.middle_name, ' '), ''), a.last_name) AS full_name,
  a.sex,
  a.birth_date,
  a.email,
  a.phone,
  c.campus_name,
  ebc.educational_background_category_name,
  ebc.educational_background_category_code,
  a.created_at
FROM `applicant` a
JOIN `campus` c ON c.campus_id = a.campus_id
JOIN `educational_background_category` ebc
  ON ebc.educational_background_category_id = a.educational_background_category_id;

CREATE VIEW `vw_application_requirements` AS
SELECT
  app.application_id,
  app.tracking_no,
  a.applicant_id,
  CONCAT(a.first_name, ' ', a.last_name) AS applicant_name,
  p.program_code,
  p.program_name,
  rt.requirement_type_name,
  rs.requirement_status_name,
  r.file_name,
  r.submitted_at,
  r.processed_at,
  r.remarks
FROM `application` app
JOIN `applicant` a ON a.applicant_id = app.applicant_id
JOIN `program` p ON p.program_id = app.program_id
LEFT JOIN `requirement` r ON r.application_id = app.application_id
LEFT JOIN `requirement_type` rt ON rt.requirement_type_id = r.requirement_type_id
LEFT JOIN `requirement_status` rs ON rs.requirement_status_id = r.requirement_status_id;

USE `schooldb`;

INSERT INTO `role` (`role_id`, `role_name`, `role_description`) VALUES
(1, 'Registrar Admin', 'Can manage registrar users, applicants, applications, and requirements'),
(2, 'Registrar Staff', 'Can encode applicants and process requirements')
ON DUPLICATE KEY UPDATE `role_description` = VALUES(`role_description`);

-- Password hash is a placeholder for local testing only. The backend should replace it when auth is implemented.
INSERT INTO `user` (`user_id`, `role_id`, `username`, `email`, `password_hash`, `first_name`, `last_name`) VALUES
(1, 1, 'admin', 'admin@example.com', '$2y$10$example.placeholder.hash.replace.in.backend', 'System', 'Admin'),
(2, 2, 'staff', 'staff@example.com', '$2y$10$example.placeholder.hash.replace.in.backend', 'Registrar', 'Staff')
ON DUPLICATE KEY UPDATE `role_id` = VALUES(`role_id`), `email` = VALUES(`email`), `first_name` = VALUES(`first_name`), `last_name` = VALUES(`last_name`);

INSERT INTO `campus` (`campus_id`, `campus_name`, `campus_location`) VALUES
(1, 'PUP Open University System', 'Sta. Mesa, Manila'),
(2, 'PUP Sta. Mesa Main Campus', 'Sta. Mesa, Manila')
ON DUPLICATE KEY UPDATE `campus_location` = VALUES(`campus_location`);

INSERT INTO `program` (`program_id`, `program_code`, `program_name`) VALUES
(1, 'BSIT', 'Bachelor of Science in Information Technology'),
(2, 'BSOA', 'Bachelor of Science in Office Administration'),
(3, 'BSMM', 'Bachelor of Science in Marketing Management'),
(4, 'BABR', 'Bachelor of Arts in Broadcasting'),
(5, 'BPA', 'Bachelor of Public Administration'),
(6, 'BSBA', 'Bachelor of Science in Business Administration'),
(7, 'BSENT', 'Bachelor of Science in Entrepreneurship'),
(8, 'BSAIS', 'Bachelor of Science in Accounting Information System')
ON DUPLICATE KEY UPDATE `program_name` = VALUES(`program_name`), `program_is_active` = 1;

INSERT INTO `educational_background_category`
(`educational_background_category_id`, `educational_background_category_name`, `educational_background_category_code`, `educational_background_category_description`) VALUES
(1, 'Senior High School Graduate', 'SHS', 'Senior High School graduate applicant'),
(2, 'Old Curriculum High School Graduate', 'OLD', 'High school graduate under the old curriculum'),
(3, 'Alternative Learning System', 'ALS', 'Alternative Learning System passer'),
(4, 'TESDA / Vocational', 'VOCATIONAL', 'Technical-vocational or TESDA applicant'),
(5, 'College Undergraduate', 'UNDERGRAD', 'Applicant with previous college units')
ON DUPLICATE KEY UPDATE
  `educational_background_category_name` = VALUES(`educational_background_category_name`),
  `educational_background_category_description` = VALUES(`educational_background_category_description`),
  `educational_background_category_is_active` = 1;

INSERT INTO `application_status`
(`application_status_id`, `application_status_name`, `application_status_description`, `application_status_color`, `application_status_is_final`) VALUES
(1, 'Pending', 'Application is encoded but not yet reviewed', 'yellow', 0),
(2, 'Received', 'Application has been received by the admission office', 'blue', 0),
(3, 'Under Review', 'Application and documents are being reviewed', 'purple', 0),
(4, 'Approved', 'Application has passed review', 'green', 1),
(5, 'Rejected', 'Application did not pass review', 'red', 1)
ON DUPLICATE KEY UPDATE `application_status_description` = VALUES(`application_status_description`);

INSERT INTO `requirement_status`
(`requirement_status_id`, `requirement_status_name`, `requirement_status_description`, `requirement_status_color`, `requirement_status_is_final`) VALUES
(1, 'Pending', 'Document has not yet been submitted or reviewed', 'yellow', 0),
(2, 'Received', 'Document has been received', 'blue', 0),
(3, 'Rejected', 'Document was rejected and needs correction', 'red', 1),
(4, 'Incomplete', 'Document was submitted but is incomplete', 'orange', 0),
(5, 'Verified', 'Document was checked and verified', 'green', 1)
ON DUPLICATE KEY UPDATE `requirement_status_description` = VALUES(`requirement_status_description`);

INSERT INTO `requirement_type` (`requirement_type_id`, `requirement_type_name`, `requirement_type_description`) VALUES
(1, 'Transcript of Records (TOR)', 'Official transcript from previous school'),
(2, 'Diploma', 'Copy of diploma'),
(3, 'PSA Birth Certificate', 'Birth certificate issued by PSA'),
(4, 'Good Moral Certificate', 'Certificate of good moral character'),
(5, 'Certificate of Completion', 'Completion certificate for ALS/TVET or related program'),
(6, 'Form 138-A', 'Senior High School report card'),
(7, 'Form 137', 'Permanent school record'),
(8, '2x2 ID Photo', 'Recent 2x2 applicant photo'),
(9, 'Admission Form', 'Completed admission application form'),
(10, 'Valid ID', 'Government or school-issued identification')
ON DUPLICATE KEY UPDATE `requirement_type_description` = VALUES(`requirement_type_description`);

INSERT INTO `rejection_reason` (`rejection_reason_id`, `rejection_reason_name`, `rejection_reason_description`) VALUES
(1, 'Unreadable Document', 'The uploaded file or scanned copy is not readable'),
(2, 'Incomplete Information', 'The document has missing or incomplete required details'),
(3, 'Wrong Document Type', 'The submitted file does not match the required document type'),
(4, 'Expired or Invalid Document', 'The document is expired, invalid, or not acceptable')
ON DUPLICATE KEY UPDATE `rejection_reason_description` = VALUES(`rejection_reason_description`);

INSERT INTO `tracking_sequences` (`tracking_sequences_id`, `entity_type`, `prefix`, `last_sequence`, `current_year`) VALUES
(1, 'APPLICATION', 'APP', 0, YEAR(CURDATE())),
(2, 'REQUIREMENT', 'REQ', 0, YEAR(CURDATE()))
ON DUPLICATE KEY UPDATE `prefix` = VALUES(`prefix`);

-- Common requirements for each educational background category.
INSERT INTO `curriculum_requirement`
(`educational_background_category_id`, `requirement_type_id`, `is_mandatory`, `is_active`) VALUES
-- SHS
(1, 3, 1, 1), (1, 4, 1, 1), (1, 6, 1, 1), (1, 7, 1, 1), (1, 8, 1, 1), (1, 9, 1, 1), (1, 10, 1, 1),
-- OLD
(2, 3, 1, 1), (2, 4, 1, 1), (2, 7, 1, 1), (2, 8, 1, 1), (2, 9, 1, 1), (2, 10, 1, 1),
-- ALS
(3, 3, 1, 1), (3, 4, 1, 1), (3, 5, 1, 1), (3, 8, 1, 1), (3, 9, 1, 1), (3, 10, 1, 1),
-- TVET / Vocational
(4, 3, 1, 1), (4, 4, 1, 1), (4, 5, 1, 1), (4, 8, 1, 1), (4, 9, 1, 1), (4, 10, 1, 1),
-- College Undergraduate
(5, 1, 1, 1), (5, 3, 1, 1), (5, 4, 1, 1), (5, 8, 1, 1), (5, 9, 1, 1), (5, 10, 1, 1)
ON DUPLICATE KEY UPDATE `is_mandatory` = VALUES(`is_mandatory`), `is_active` = VALUES(`is_active`);

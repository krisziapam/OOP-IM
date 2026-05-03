USE `schooldb`;

INSERT INTO `applicant`
(`applicant_id`, `first_name`, `middle_name`, `last_name`, `sex`, `birth_date`, `email`, `phone`, `address`, `campus_id`, `educational_background_category_id`, `created_by_user_id`) VALUES
(1, 'Juan', 'Santos', 'Dela Cruz', 'Male', '2005-05-10', 'juan.delacruz@example.com', '09123456789', 'Sta. Mesa, Manila', 1, 5, 1),
(2, 'Maria', NULL, 'Santos', 'Female', '2006-01-15', 'maria.santos@example.com', '09987654321', 'Quezon City', 1, 1, 1)
ON DUPLICATE KEY UPDATE `phone` = VALUES(`phone`), `address` = VALUES(`address`);

INSERT INTO `application`
(`application_id`, `applicant_id`, `program_id`, `campus_id`, `application_status_id`, `submission_method`, `tracking_no`, `application_date`, `academic_year`, `semester`, `remarks`) VALUES
(1, 1, 1, 1, 1, 'Personal', 'APP-2026-0001', CURDATE(), '2026-2027', '1st Semester', 'Sample college undergraduate application'),
(2, 2, 2, 1, 1, 'Courier', 'APP-2026-0002', CURDATE(), '2026-2027', '1st Semester', 'Sample SHS graduate application')
ON DUPLICATE KEY UPDATE `application_status_id` = VALUES(`application_status_id`), `remarks` = VALUES(`remarks`);

INSERT INTO `requirement`
(`application_id`, `requirement_type_id`, `requirement_status_id`, `remarks`) VALUES
(1, 1, 1, 'TOR pending'),
(1, 3, 2, 'PSA received'),
(2, 6, 1, 'Form 138-A pending'),
(2, 7, 1, 'Form 137 pending')
ON DUPLICATE KEY UPDATE `requirement_status_id` = VALUES(`requirement_status_id`), `remarks` = VALUES(`remarks`);

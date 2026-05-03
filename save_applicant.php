<?php
include "config.php";

$first_name = $_POST['first_name'];
$middle_name = $_POST['middle_name'];
$last_name = $_POST['last_name'];
$sex = $_POST['sex'];
$birth_date = $_POST['birth_date'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$campus_id = $_POST['campus_id'];
$educational_background_category_id = $_POST['educational_background_category_id'];

$sql = "INSERT INTO applicant 
(first_name, middle_name, last_name, sex, birth_date, email, phone, campus_id, educational_background_category_id)
VALUES 
('$first_name', '$middle_name', '$last_name', '$sex', '$birth_date', '$email', '$phone', '$campus_id', '$educational_background_category_id')";

if (mysqli_query($conn, $sql)) {
    header("Location: applicants.php");
    exit();
} else {
    echo "Error: " . mysqli_error($conn);
}
?>

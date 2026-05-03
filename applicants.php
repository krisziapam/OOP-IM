<?php
include "config.php";

$sql = "
    SELECT 
        a.applicant_id,
        CONCAT_WS(' ', a.first_name, a.middle_name, a.last_name) AS full_name,
        a.sex,
        a.birth_date,
        a.email,
        a.phone,
        c.campus_name,
        e.educational_background_category_name
    FROM applicant a
    LEFT JOIN campus c 
        ON a.campus_id = c.campus_id
    LEFT JOIN educational_background_category e 
        ON a.educational_background_category_id = e.educational_background_category_id
    ORDER BY a.applicant_id ASC
";

$result = mysqli_query($conn, $sql);

if (!$result) {
    die("Query failed: " . mysqli_error($conn));
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Applicants</title>
</head>
<body>

<h1>Applicants</h1>

<a href="add_applicant.php">Add Applicant</a>
<br><br>

<table border="1" cellpadding="10">
    <tr>
        <th>ID</th>
        <th>Full Name</th>
        <th>Sex</th>
        <th>Birth Date</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Campus</th>
        <th>Educational Background</th>
    </tr>

    <?php while ($row = mysqli_fetch_assoc($result)) { ?>
        <tr>
            <td><?php echo htmlspecialchars($row['applicant_id'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['full_name'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['sex'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['birth_date'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['email'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['phone'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['campus_name'] ?? ''); ?></td>
            <td><?php echo htmlspecialchars($row['educational_background_category_name'] ?? ''); ?></td>
        </tr>
    <?php } ?>
</table>

<br>
<a href="index.php">Back</a>

</body>
</html>

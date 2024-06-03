<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include "connection.php"; // Assuming this file contains the database connection code

try {
    // Prepare and execute SQL query to fetch all sales data
    $sql = "SELECT * FROM tblsales ORDER BY sales_id DESC";
    $stmt = $conn->prepare($sql); 
    $stmt->execute();

    // Fetch results
    $salesData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Return JSON response
    echo json_encode($salesData);
} catch (PDOException $e) {
    // Handle database errors
    echo json_encode(array('error' => 'Database error: ' . $e->getMessage()));
}
?>

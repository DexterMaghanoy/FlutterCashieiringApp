<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include "connection.php";

try {
    // Prepare and execute SQL query
    $sql = "SELECT prod_id, prod_name, prod_price FROM tblproduct";
    $stmt = $conn->prepare($sql); 
    $stmt->execute();

    // Fetch results
    $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Return JSON response
    echo json_encode($returnValue);
} catch (PDOException $e) {
    // Handle database errors
    echo json_encode(array('error' => 'Database error: ' . $e->getMessage()));
}
?>

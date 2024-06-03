<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include "connection.php";

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Fetch total value, number of products, and total quantity
        $sql = "SELECT SUM(prod_quantity * prod_price) AS total_value, 
                       COUNT(*) AS total_products, 
                       SUM(prod_quantity) AS total_quantity 
                FROM tblproduct";
        $stmt = $conn->query($sql);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        echo json_encode($result);
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Database error']);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>

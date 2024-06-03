<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include "connection.php";

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Fetch the total value of all products
    $sqlTotalValue = "SELECT SUM(prod_quantity * prod_price) AS total_value FROM tblproduct";
    $stmtTotalValue = $conn->prepare($sqlTotalValue);
    $stmtTotalValue->execute();
    $totalValue = $stmtTotalValue->fetch(PDO::FETCH_ASSOC)['total_value'];

    echo json_encode(['total_value' => $totalValue]);
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>

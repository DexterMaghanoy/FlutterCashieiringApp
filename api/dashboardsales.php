<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include "connection.php";

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Fetch total number of sales, total value of all sales, and total quantity of products sold
        $sql = "SELECT COUNT(*) AS total_sales,
                       SUM(sales_total) AS total_sales_value,
                       SUM(sales_quantity) AS total_products_sold
                FROM tblsales";
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

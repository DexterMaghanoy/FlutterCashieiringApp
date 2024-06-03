<?php
include "headers.php";
include "connection.php";

$json_data = file_get_contents("php://input");
$data = json_decode($json_data, true);

$sprod_id = $data["sprod_id"]; // Assuming 'sprod_id' is provided in the data
$sales_quantity = $data["sales_quantity"];
$sales_price = $data["sales_price"];
$sales_total = $data["sales_total"];
$sales_productname = $data["sales_productname"];

$sql = "INSERT INTO tblsales (sprod_id, sales_quantity, sales_price, sales_total, sales_productname)";
$sql .= " VALUES (:sprod_id, :sales_quantity, :sales_price, :sales_total, :sales_productname)";

try {
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":sprod_id", $sprod_id);
    $stmt->bindParam(":sales_quantity", $sales_quantity);
    $stmt->bindParam(":sales_price", $sales_price);
    $stmt->bindParam(":sales_total", $sales_total);
    $stmt->bindParam(":sales_productname", $sales_productname);

    if ($stmt->execute()) {
        $returnValue = ['status' => 'success', 'message' => 'Record inserted successfully'];
    } else {
        $returnValue = ['status' => 'error', 'message' => 'Error inserting record'];
    }
} catch (PDOException $e) {
    $returnValue = ['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()];
}

echo json_encode($returnValue);
?>

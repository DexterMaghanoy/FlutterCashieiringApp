<?php
include "headers.php";
include "connection.php";

// Ensure that the request is a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('HTTP/1.1 405 Method Not Allowed');
    exit;
}

// Retrieve data from the POST request
$data = json_decode(file_get_contents('php://input'), true);

// Check if required fields are present in the data
if (
    !isset($data['prod_code']) ||
    !isset($data['prod_name']) ||
    !isset($data['prod_quantity']) ||
    !isset($data['prod_price'])
) {
    header('HTTP/1.1 400 Bad Request');
    echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
    exit;
}

$prodcode = $data['prod_code'];
$prodname = $data['prod_name'];
$prodquantity = $data['prod_quantity'];
$prodprice = $data['prod_price'];

// Validate data (you may want to perform more thorough validation)
if (empty($prodcode) || empty($prodname) || !is_numeric($prodquantity) || !is_numeric($prodprice)) {
    header('HTTP/1.1 400 Bad Request');
    echo json_encode(['status' => 'error', 'message' => 'Invalid data']);
    exit;
}

// Prepare and execute the SQL statement
$sql = "INSERT INTO tblproduct (prod_code, prod_name, prod_quantity, prod_price) VALUES (:prodcode, :prodname, :prodquantity, :prodprice)";
$stmt = $conn->prepare($sql);
$stmt->bindParam(":prodcode", $prodcode);
$stmt->bindParam(":prodname", $prodname);
$stmt->bindParam(":prodquantity", $prodquantity);
$stmt->bindParam(":prodprice", $prodprice);
$stmt->execute();

// Check if the insertion was successful
$returnValue = $stmt->rowCount() > 0 ? ['status' => 'success', 'message' => 'Product added successfully'] : ['status' => 'error', 'message' => 'Failed to add product'];

// Send the response
echo json_encode($returnValue);
?>

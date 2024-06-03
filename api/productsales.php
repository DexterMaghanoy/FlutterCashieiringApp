<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include("connection.php");

$itemCode = $_GET['prod_code'];

try {
    $stmt = $conn->prepare("SELECT * FROM tblproduct WHERE prod_code = :prodcode");
    $stmt->bindParam(':prodcode', $itemCode);
    $stmt->execute();

    $games = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $json_games = json_encode($games);

    echo $json_games;
} catch (PDOException $e) {
    echo json_encode(array('error' => $e->getMessage()));
    exit();
}

$conn = null;
?>
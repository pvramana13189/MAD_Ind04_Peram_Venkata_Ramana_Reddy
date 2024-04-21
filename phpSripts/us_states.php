<?php
$server = "mysql.cs.okstate.edu";
$username = "vperam";
$password = "ho+Jam91";
$database = "vperam";

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Create connection
$conn = mysqli_connect($server, $username, $password, $database);

$query = "SELECT * FROM states";
$result = mysqli_query($conn, $query);
$response = array();

while($row = mysqli_fetch_assoc($result)) {
    $response[] = $row;
}

header('Content-Type: application/json ');
echo json_encode($response);

mysqli_close($conn);
?>

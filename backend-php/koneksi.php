<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

$connect = new mysqli("localhost", "root", "", "db_pegawai");

if ($connect->connect_error) {
    echo json_encode([
        "success" => false,
        "message" => "Koneksi database gagal: " . $connect->connect_error
    ]);
    exit();
}
?>
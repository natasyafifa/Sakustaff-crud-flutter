<?php
include 'koneksi.php';

$query = "SELECT * FROM tb_pegawai ORDER BY id DESC";
$result = $connect->query($query);

$data = array();

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>
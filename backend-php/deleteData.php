<?php
include 'koneksi.php';

$id = $_POST['id'] ?? '';

if ($id == '') {
    echo json_encode([
        "success" => false,
        "message" => "ID tidak ditemukan"
    ]);
    exit();
}

$query = "DELETE FROM tb_pegawai WHERE id = '$id'";

if ($connect->query($query)) {
    echo json_encode([
        "success" => true,
        "message" => "Data berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal menghapus data: " . $connect->error
    ]);
}
?>
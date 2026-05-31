<?php
include 'koneksi.php';

$nama = $_POST['namaPegawai'] ?? '';
$posisi = $_POST['posisiPegawai'] ?? '';
$gaji = $_POST['gajiPegawai'] ?? '';
$alamat = $_POST['alamatPegawai'] ?? '';
$latitude = $_POST['latitude'] ?? '';
$longitude = $_POST['longitude'] ?? '';

$fotoName = "";

if (isset($_FILES['fotoPegawai']) && $_FILES['fotoPegawai']['error'] == 0) {
    $folder = "uploads/";

    if (!is_dir($folder)) {
        mkdir($folder, 0777, true);
    }

    $namaFileAsli = basename($_FILES["fotoPegawai"]["name"]);
    $ext = pathinfo($namaFileAsli, PATHINFO_EXTENSION);
    $fotoName = "pegawai_" . time() . "." . $ext;

    $targetFile = $folder . $fotoName;

    move_uploaded_file($_FILES["fotoPegawai"]["tmp_name"], $targetFile);
}

$query = "INSERT INTO tb_pegawai 
(nama, posisi, gaji, foto, latitude, longitude, alamat) 
VALUES 
('$nama', '$posisi', '$gaji', '$fotoName', '$latitude', '$longitude', '$alamat')";

if ($connect->query($query)) {
    echo json_encode([
        "success" => true,
        "message" => "Data berhasil ditambahkan"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal menambahkan data: " . $connect->error
    ]);
}
?>
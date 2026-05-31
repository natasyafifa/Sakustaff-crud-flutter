<?php
include 'koneksi.php';

$id = $_POST['id'] ?? '';
$nama = $_POST['namaPegawai'] ?? '';
$posisi = $_POST['posisiPegawai'] ?? '';
$gaji = $_POST['gajiPegawai'] ?? '';
$alamat = $_POST['alamatPegawai'] ?? '';
$latitude = $_POST['latitude'] ?? '';
$longitude = $_POST['longitude'] ?? '';
$hapusFoto = $_POST['hapusFoto'] ?? '0';

if ($id == '') {
    echo json_encode([
        "success" => false,
        "message" => "ID tidak ditemukan"
    ]);
    exit();
}

if ($hapusFoto == '1') {
    $query = "UPDATE tb_pegawai SET 
        nama = '$nama',
        posisi = '$posisi',
        gaji = '$gaji',
        foto = '',
        latitude = '$latitude',
        longitude = '$longitude',
        alamat = '$alamat'
        WHERE id = '$id'";
} else if (isset($_FILES['fotoPegawai']) && $_FILES['fotoPegawai']['error'] == 0) {
    $folder = __DIR__ . "/uploads/";

    if (!is_dir($folder)) {
        mkdir($folder, 0777, true);
    }

    $namaFileAsli = basename($_FILES["fotoPegawai"]["name"]);
    $ext = pathinfo($namaFileAsli, PATHINFO_EXTENSION);

    if ($ext == "") {
        $ext = "jpg";
    }

    $fotoName = "pegawai_" . time() . "." . $ext;
    $targetFile = $folder . $fotoName;

    move_uploaded_file($_FILES["fotoPegawai"]["tmp_name"], $targetFile);

    $query = "UPDATE tb_pegawai SET 
        nama = '$nama',
        posisi = '$posisi',
        gaji = '$gaji',
        foto = '$fotoName',
        latitude = '$latitude',
        longitude = '$longitude',
        alamat = '$alamat'
        WHERE id = '$id'";
} else {
    $query = "UPDATE tb_pegawai SET 
        nama = '$nama',
        posisi = '$posisi',
        gaji = '$gaji',
        latitude = '$latitude',
        longitude = '$longitude',
        alamat = '$alamat'
        WHERE id = '$id'";
}

if ($connect->query($query)) {
    echo json_encode([
        "success" => true,
        "message" => "Data berhasil diedit"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal mengedit data: " . $connect->error
    ]);
}
?>
<?php
header("Access-Control-Allow-Origin: *");

$file = $_GET['file'] ?? '';

if ($file == '') {
    http_response_code(404);
    exit();
}

$file = basename($file);
$path = __DIR__ . "/uploads/" . $file;

if (!file_exists($path)) {
    http_response_code(404);
    exit();
}

$ext = strtolower(pathinfo($path, PATHINFO_EXTENSION));

if ($ext == "jpg" || $ext == "jpeg") {
    header("Content-Type: image/jpeg");
} elseif ($ext == "png") {
    header("Content-Type: image/png");
} elseif ($ext == "gif") {
    header("Content-Type: image/gif");
} else {
    header("Content-Type: application/octet-stream");
}

readfile($path);
exit();
?>
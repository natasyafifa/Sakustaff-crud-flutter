# SakuStaff - CRUD Pegawai Flutter

SakuStaff adalah aplikasi CRUD Data Pegawai berbasis Flutter dengan tema Sakura. Aplikasi ini digunakan untuk mengelola data pegawai, mulai dari menampilkan, menambahkan, mengedit, hingga menghapus data.

Aplikasi ini dilengkapi dengan fitur import foto pegawai dari galeri dan deteksi lokasi GPS otomatis untuk mengisi latitude dan longitude.

## Fitur Aplikasi

- Splash screen dengan tema Sakura
- Menampilkan daftar data pegawai
- Menambahkan data pegawai
- Mengedit data pegawai
- Menghapus data pegawai
- Import foto pegawai dari galeri
- Deteksi lokasi GPS otomatis
- Menampilkan latitude dan longitude
- Tampilan aplikasi dengan tema pink Sakura

## Teknologi yang Digunakan

- Flutter
- Dart
- PHP
- MySQL
- Package http
- Package image_picker
- Package geolocator
- Package animated_splash_screen
- Package page_transition

## Struktur Database

Database yang digunakan bernama `db_pegawai` dengan tabel `tb_pegawai`.

| Kolom | Tipe Data | Keterangan |
|---|---|---|
| id | INT | Primary key auto increment |
| nama | VARCHAR | Nama pegawai |
| posisi | VARCHAR | Posisi atau jabatan pegawai |
| gaji | INT | Gaji pegawai |
| foto | VARCHAR | Nama file foto pegawai |
| latitude | DOUBLE | Koordinat latitude |
| longitude | DOUBLE | Koordinat longitude |
| alamat | TEXT | Alamat pegawai |

## Struktur Backend PHP

File PHP disimpan pada folder `pegawai` di dalam `htdocs` atau `www`.

```text
pegawai/
├── koneksi.php
├── getPegawai.php
├── addPegawai.php
├── editPegawai.php
├── deleteData.php
├── showFoto.php
└── uploads/

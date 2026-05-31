class Pegawai {
  final String id;
  final String nama;
  final String posisi;
  final String gaji;
  final String foto;
  final String latitude;
  final String longitude;
  final String alamat;

  Pegawai({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.gaji,
    required this.foto,
    required this.latitude,
    required this.longitude,
    required this.alamat,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      posisi: json['posisi']?.toString() ?? '',
      gaji: json['gaji']?.toString() ?? '',
      foto: json['foto']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
    );
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'pegawai.dart';

class ApiServices {
  // Kalau run di Chrome / Flutter Web:
  static const String baseUrl = 'http://localhost/pegawai';

  // Kalau nanti run di Android Emulator, ganti jadi:
  // static const String baseUrl = 'http://10.0.2.2/pegawai';

  // Kalau run di HP Android asli, ganti jadi IP laptop:
  // static const String baseUrl = 'http://192.168.1.18/pegawai';

  static String getFotoUrl(String namaFoto) {
    if (namaFoto.isEmpty) {
      return '';
    }

    if (namaFoto.startsWith('http')) {
      return namaFoto;
    }

    // Lewat showFoto.php supaya aman di Flutter Web
    return '$baseUrl/showFoto.php?file=$namaFoto';
  }

  static Future<List<Pegawai>> getPegawai() async {
    final response = await http.get(
      Uri.parse('$baseUrl/getPegawai.php'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Pegawai.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data pegawai');
    }
  }

  static Future<void> tambahFotoKeRequest(
    http.MultipartRequest request,
    XFile? foto,
  ) async {
    if (foto == null) {
      return;
    }

    if (kIsWeb) {
      final bytes = await foto.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'fotoPegawai',
          bytes,
          filename: foto.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'fotoPegawai',
          foto.path,
        ),
      );
    }
  }

  static Future<bool> tambahPegawai({
    required String nama,
    required String posisi,
    required String gaji,
    required String alamat,
    required String latitude,
    required String longitude,
    XFile? foto,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/addPegawai.php'),
    );

    request.fields['namaPegawai'] = nama;
    request.fields['posisiPegawai'] = posisi;
    request.fields['gajiPegawai'] = gaji;
    request.fields['alamatPegawai'] = alamat;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;

    await tambahFotoKeRequest(request, foto);

    final response = await request.send();

    return response.statusCode == 200;
  }

  static Future<bool> editPegawai({
    required String id,
    required String nama,
    required String posisi,
    required String gaji,
    required String alamat,
    required String latitude,
    required String longitude,
    XFile? foto,
    bool hapusFoto = false,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/editPegawai.php'),
    );

    request.fields['id'] = id;
    request.fields['namaPegawai'] = nama;
    request.fields['posisiPegawai'] = posisi;
    request.fields['gajiPegawai'] = gaji;
    request.fields['alamatPegawai'] = alamat;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;
    request.fields['hapusFoto'] = hapusFoto ? '1' : '0';

    if (!hapusFoto) {
      await tambahFotoKeRequest(request, foto);
    }

    final response = await request.send();

    return response.statusCode == 200;
  }

  static Future<bool> hapusPegawai(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deleteData.php'),
      body: {
        'id': id,
      },
    );

    return response.statusCode == 200;
  }
}
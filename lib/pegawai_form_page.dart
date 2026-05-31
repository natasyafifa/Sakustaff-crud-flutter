import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'api_services.dart';
import 'pegawai.dart';

class PegawaiFormPage extends StatefulWidget {
  final Pegawai? pegawai;

  const PegawaiFormPage({
    super.key,
    this.pegawai,
  });

  @override
  State<PegawaiFormPage> createState() => _PegawaiFormPageState();
}

class _PegawaiFormPageState extends State<PegawaiFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController posisiController = TextEditingController();
  final TextEditingController gajiController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? foto;
  bool loading = false;
  bool loadingLokasi = false;
  bool hapusFoto = false;

  bool get isEdit => widget.pegawai != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      namaController.text = widget.pegawai!.nama;
      posisiController.text = widget.pegawai!.posisi;
      gajiController.text = widget.pegawai!.gaji;
      alamatController.text = widget.pegawai!.alamat;
      latitudeController.text = widget.pegawai!.latitude;
      longitudeController.text = widget.pegawai!.longitude;
    }

    ambilLokasi();
  }

  @override
  void dispose() {
    namaController.dispose();
    posisiController.dispose();
    gajiController.dispose();
    alamatController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> pilihFoto() async {
    final XFile? hasil = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (hasil != null) {
      setState(() {
        foto = hasil;
        hapusFoto = false;
      });
    }
  }

  Future<void> ambilLokasi() async {
    setState(() {
      loadingLokasi = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        tampilPesan('GPS belum aktif');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        tampilPesan('Izin lokasi ditolak');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        tampilPesan('Izin lokasi ditolak permanen');
        return;
      }

      Position posisi = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitudeController.text = posisi.latitude.toString();
      longitudeController.text = posisi.longitude.toString();
    } catch (e) {
      tampilPesan('Gagal mengambil lokasi: $e');
    } finally {
      if (mounted) {
        setState(() {
          loadingLokasi = false;
        });
      }
    }
  }

  void tampilPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
      ),
    );
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      bool berhasil;

      if (isEdit) {
        berhasil = await ApiServices.editPegawai(
          id: widget.pegawai!.id,
          nama: namaController.text,
          posisi: posisiController.text,
          gaji: gajiController.text,
          alamat: alamatController.text,
          latitude: latitudeController.text,
          longitude: longitudeController.text,
          foto: foto,
          hapusFoto: hapusFoto,
        );
      } else {
        berhasil = await ApiServices.tambahPegawai(
          nama: namaController.text,
          posisi: posisiController.text,
          gaji: gajiController.text,
          alamat: alamatController.text,
          latitude: latitudeController.text,
          longitude: longitudeController.text,
          foto: foto,
        );
      }

      if (!mounted) return;

      if (berhasil) {
        tampilPesan(
          isEdit ? 'Data berhasil diedit' : 'Data berhasil ditambahkan',
        );
        Navigator.pop(context);
      } else {
        tampilPesan('Gagal menyimpan data');
      }
    } catch (e) {
      tampilPesan('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget tampilanFotoKosong() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.photo_library,
          size: 60,
          color: const Color(0xfff48fb1),
        ),
        SizedBox(height: 10),
        Text(
          'Tap untuk import foto',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget previewFoto() {
    if (hapusFoto) {
      return tampilanFotoKosong();
    }

    if (foto != null) {
      return Image.network(
        foto!.path,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
      );
    }

    if (isEdit && widget.pegawai!.foto.isNotEmpty) {
      return Image.network(
        ApiServices.getFotoUrl(widget.pegawai!.foto),
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              size: 70,
              color: Colors.grey,
            ),
          );
        },
      );
    }

    return tampilanFotoKosong();
  }

  Widget inputData({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label wajib diisi';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget tombolHapusFoto() {
    if (!isEdit) {
      return const SizedBox();
    }

    if (widget.pegawai!.foto.isEmpty) {
      return const SizedBox();
    }

    if (hapusFoto) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                foto = null;
                hapusFoto = true;
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Hapus Foto'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Pegawai' : 'Tambah Pegawai',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pilihFoto,
                child: Container(
                  width: double.infinity,
                  height: 190,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xfff48fb1).withOpacity(0.4),
                    ),
                  ),
                  child: previewFoto(),
                ),
              ),

              tombolHapusFoto(),

              const SizedBox(height: 18),

              inputData(
                controller: namaController,
                label: 'Nama Pegawai',
                icon: Icons.person,
              ),

              inputData(
                controller: posisiController,
                label: 'Posisi Pegawai',
                icon: Icons.work,
              ),

              inputData(
                controller: gajiController,
                label: 'Gaji Pegawai',
                icon: Icons.payments,
                keyboardType: TextInputType.number,
              ),

              inputData(
                controller: alamatController,
                label: 'Alamat Pegawai',
                icon: Icons.home,
                maxLines: 3,
              ),

              Row(
                children: [
                  Expanded(
                    child: inputData(
                      controller: latitudeController,
                      label: 'Latitude',
                      icon: Icons.my_location,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: inputData(
                      controller: longitudeController,
                      label: 'Longitude',
                      icon: Icons.location_on,
                      readOnly: true,
                    ),
                  ),
                ],
              ),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: loadingLokasi ? null : ambilLokasi,
                  icon: loadingLokasi
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.gps_fixed),
                  label: Text(
                    loadingLokasi
                        ? 'Mengambil Lokasi...'
                        : 'Ambil Lokasi GPS',
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff48fb1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: loading ? null : simpanData,
                  icon: loading
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    isEdit ? 'Simpan Perubahan' : 'Simpan Data',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
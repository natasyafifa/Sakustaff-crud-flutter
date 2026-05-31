import 'package:flutter/material.dart';
import 'api_services.dart';
import 'pegawai.dart';
import 'pegawai_form_page.dart';

class PegawaiDetailPage extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiDetailPage({
    super.key,
    required this.pegawai,
  });

  @override
  State<PegawaiDetailPage> createState() => _PegawaiDetailPageState();
}

class _PegawaiDetailPageState extends State<PegawaiDetailPage> {
  bool loading = false;

  Future<void> konfirmasiHapus() async {
    final hasil = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text(
            'Yakin ingin menghapus data ${widget.pegawai.nama}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (hasil == true) {
      hapusData();
    }
  }

  Future<void> hapusData() async {
    setState(() {
      loading = true;
    });

    try {
      final berhasil = await ApiServices.hapusPegawai(widget.pegawai.id);

      if (!mounted) return;

      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dihapus'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus data'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget fotoPegawai() {
    final String foto = widget.pegawai.foto.trim();

    if (foto.isEmpty) {
      return const CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xffffedf4),
        child: Icon(
          Icons.person,
          size: 70,
          color: const Color(0xfff48fb1),
        ),
      );
    }

    final String urlFoto = ApiServices.getFotoUrl(foto);

    return CircleAvatar(
      radius: 60,
      backgroundColor: const Color(0xffffedf4),
      child: ClipOval(
        child: Image.network(
          urlFoto,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.broken_image,
              size: 60,
              color: const Color(0xfff48fb1),
            );
          },
        ),
      ),
    );
  }

  Widget itemDetail(IconData icon, String judul, String isi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xfff48fb1),
        ),
        title: Text(judul),
        subtitle: Text(
          isi.isEmpty ? '-' : isi,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pegawai = widget.pegawai;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pegawai'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    fotoPegawai(),
                    const SizedBox(height: 15),
                    Text(
                      pegawai.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pegawai.posisi,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pegawai.foto.isEmpty
                          ? 'Foto belum tersimpan'
                          : 'File foto: ${pegawai.foto}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            itemDetail(
              Icons.payments,
              'Gaji',
              'Rp ${pegawai.gaji}',
            ),

            itemDetail(
              Icons.home,
              'Alamat',
              pegawai.alamat,
            ),

            itemDetail(
              Icons.my_location,
              'Latitude',
              pegawai.latitude,
            ),

            itemDetail(
              Icons.location_on,
              'Longitude',
              pegawai.longitude,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff48fb1),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PegawaiFormPage(
                            pegawai: pegawai,
                          ),
                        ),
                      );

                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    icon: loading
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.delete),
                    label: const Text('Hapus'),
                    onPressed: loading ? null : konfirmasiHapus,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'api_services.dart';
import 'pegawai.dart';
import 'pegawai_form_page.dart';
import 'pegawai_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color sakuraPink = Color(0xfff48fb1);
  static const Color sakuraSoft = Color(0xffffedf4);
  static const Color sakuraDark = Color(0xffad5274);

  late Future<List<Pegawai>> dataPegawai;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  void ambilData() {
    dataPegawai = ApiServices.getPegawai();
  }

  Future<void> refreshData() async {
    setState(() {
      ambilData();
    });
  }

  Widget fotoPegawai(Pegawai pegawai) {
    if (pegawai.foto.isEmpty) {
      return const CircleAvatar(
        radius: 28,
        backgroundColor: sakuraSoft,
        child: Icon(
          Icons.person,
          color: sakuraPink,
        ),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: sakuraSoft,
      backgroundImage: NetworkImage(
        ApiServices.getFotoUrl(pegawai.foto),
      ),
    );
  }

  Widget headerHalaman() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xfff48fb1),
            Color(0xffffc1d6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: sakuraPink.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.local_florist,
              color: sakuraPink,
              size: 34,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SakuStaff',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelola data pegawai dengan foto & GPS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tampilanKosong() {
    return ListView(
      children: const [
        SizedBox(height: 110),
        Icon(
          Icons.local_florist_outlined,
          size: 85,
          color: sakuraPink,
        ),
        SizedBox(height: 14),
        Center(
          child: Text(
            'Belum ada data pegawai',
            style: TextStyle(
              fontSize: 16,
              color: sakuraDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget tampilanError(Object? error) {
    return ListView(
      children: [
        const SizedBox(height: 110),
        const Icon(
          Icons.wifi_off,
          size: 80,
          color: sakuraPink,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Data belum bisa dimuat.\n'
            'Pastikan PHP API sudah dibuat dan baseUrl sudah benar.\n\n'
            '$error',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: sakuraDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget cardPegawai(Pegawai pegawai) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: fotoPegawai(pegawai),
        title: Text(
          pegawai.nama,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: sakuraDark,
          ),
        ),
        subtitle: Text(
          '${pegawai.posisi}\nGaji: Rp ${pegawai.gaji}',
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: sakuraPink,
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PegawaiDetailPage(
                pegawai: pegawai,
              ),
            ),
          );

          refreshData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SakuStaff'),
      ),
      body: RefreshIndicator(
        color: sakuraPink,
        onRefresh: refreshData,
        child: FutureBuilder<List<Pegawai>>(
          future: dataPegawai,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: sakuraPink,
                ),
              );
            }

            if (snapshot.hasError) {
              return tampilanError(snapshot.error);
            }

            final pegawai = snapshot.data ?? [];

            if (pegawai.isEmpty) {
              return Column(
                children: [
                  headerHalaman(),
                  Expanded(
                    child: tampilanKosong(),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 85),
              itemCount: pegawai.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return headerHalaman();
                }

                final item = pegawai[index - 1];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: cardPegawai(item),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: sakuraPink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PegawaiFormPage(),
            ),
          );

          refreshData();
        },
      ),
    );
  }
}
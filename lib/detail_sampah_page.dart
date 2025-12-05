import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailSampahPage extends StatelessWidget {
  final QueryDocumentSnapshot data;

  const DetailSampahPage({Key? key, required this.data}) : super(key: key);

  Color getKategoriColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'plastik':
        return Colors.blue;
      case 'kertas':
        return Colors.orange;
      case 'logam':
        return Colors.grey;
      case 'kaca':
        return Colors.green;
      case 'organik':
        return Colors.brown;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final warna = getKategoriColor(data['kategori']);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Sampah"),
        backgroundColor: warna,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: warna,
                    child: Icon(
                      Icons.delete_outline,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildItem("Nama Sampah", data['nama_sampah']),
                buildItem("Kategori", data['kategori']),
                buildItem("Nama Siswa", data['nama']),
                buildItem("Kelas", data['kelas']),
                buildItem("NISN", data['nisn']),
                buildItem(
                  "Tanggal",
                  DateFormat('dd MMM yyyy – HH:mm')
                      .format(data['waktu'].toDate()),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("Hapus Data"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('sampah')
                          .doc(data.id)
                          .delete();

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'detail_sampah_page.dart';

class ListSampahPage extends StatefulWidget {
  final String userId;
  const ListSampahPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ListSampahPage> createState() => _ListSampahPageState();
}

class _ListSampahPageState extends State<ListSampahPage> {
  DateTime? selectedDate;

  // ================== WARNA PER KATEGORI ==================
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

  // ================== FILTER TANGGAL ==================
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ================== FILTER HARI ==================
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? "Semua Tanggal"
                      : DateFormat('dd MMM yyyy').format(selectedDate!),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: const Text("Filter Hari"),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2035),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(width: 10),
              if (selectedDate != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectedDate = null;
                    });
                  },
                ),
            ],
          ),
        ),

        // ================== LIST DATA ==================
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sampah')
                .where('user_id', isEqualTo: widget.userId)
                .orderBy('waktu', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              // ================== FILTER HARI ==================
              final filteredDocs = selectedDate == null
                  ? docs
                  : docs.where((doc) {
                      final waktu = (doc['waktu'] as Timestamp).toDate();
                      return isSameDay(waktu, selectedDate!);
                    }).toList();

              if (filteredDocs.isEmpty) {
                return const Center(child: Text("Belum ada data"));
              }

              return ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final data = filteredDocs[index];
                  final warna = getKategoriColor(data['kategori']);

                  return Card(
                    color: warna.withOpacity(0.15),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailSampahPage(data: data),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: warna,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      title: Text(
                        data['nama_sampah'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kategori: ${data['kategori']}"),
                          Text(
                            "Tanggal: ${DateFormat('dd MMM yyyy – HH:mm').format(data['waktu'].toDate())}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('sampah')
                              .doc(data.id)
                              .delete();
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ListSampahPage extends StatefulWidget {
  final String userId;
  const ListSampahPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ListSampahPage> createState() => _ListSampahPageState();
}

class _ListSampahPageState extends State<ListSampahPage> {
  DateTime? selectedDate;

  /// ✅ Ambil data Firestore + filter hari
  Stream<QuerySnapshot> getSampahStream() {
    final baseQuery = FirebaseFirestore.instance
        .collection('sampah')
        .where('user_id', isEqualTo: widget.userId);

    if (selectedDate == null) {
      return baseQuery.orderBy('waktu', descending: true).snapshots();
    } else {
      DateTime startOfDay = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        0,
        0,
        0,
      );

      DateTime endOfDay = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        23,
        59,
        59,
      );

      return baseQuery
          .where('waktu', isGreaterThanOrEqualTo: startOfDay)
          .where('waktu', isLessThanOrEqualTo: endOfDay)
          .orderBy('waktu', descending: true)
          .snapshots();
    }
  }

  /// ✅ PILIH TANGGAL
  void pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =======================
        // ✅ FILTER TANGGAL
        // =======================
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? "Semua Tanggal"
                      : "Tanggal: ${DateFormat('dd MMM yyyy').format(selectedDate!)}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: pilihTanggal,
              ),
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

        const Divider(),

        // =======================
        // ✅ LIST DATA SAMPAH
        // =======================
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getSampahStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada data"));
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  String nama = data['nama'] ?? '-';
                  String kelas = data['kelas'] ?? '-';
                  String kategori = data['kategori'] ?? '-';

                  Timestamp waktuTimestamp = data['waktu'] ?? Timestamp.now();

                  final waktu = DateFormat('dd MMM yyyy • HH:mm')
                      .format(waktuTimestamp.toDate());

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.delete_outline),
                      title: Text(nama),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kelas: $kelas"),
                          Text("Kategori: $kategori"),
                          Text("Waktu: $waktu"),
                        ],
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

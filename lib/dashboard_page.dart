import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  const DashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();

  Stream<Map<String, int>> getData() async* {
    final snapshot = await FirebaseFirestore.instance
        .collection('sampah')
        .where('user_id', isEqualTo: widget.userId)
        .get();

    Map<String, int> hasil = {};

    for (var doc in snapshot.docs) {
      Timestamp waktu = doc['waktu'];
      DateTime tanggal = waktu.toDate();

      String t1 = DateFormat('yyyy-MM-dd').format(tanggal);
      String t2 = DateFormat('yyyy-MM-dd').format(selectedDate);

      if (t1 == t2) {
        String kategori = doc['kategori'];
        hasil[kategori] = (hasil[kategori] ?? 0) + 1;
      }
    }

    yield hasil;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ PILIH TANGGAL
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            icon: Icon(Icons.calendar_today),
            label: Text(
              DateFormat('dd MMM yyyy').format(selectedDate),
            ),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );

              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
          ),
        ),

        Expanded(
          child: StreamBuilder<Map<String, int>>(
            stream: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;
              if (data.isEmpty) {
                return Center(
                  child: Text("Tidak ada data di tanggal ini"),
                );
              }

              final warna = [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.teal,
              ];

              int index = 0;
              final sections = data.entries.map((e) {
                final section = PieChartSectionData(
                  value: e.value.toDouble(),
                  title: "${e.key}\n${e.value}",
                  radius: 75,
                  color: warna[index % warna.length],
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
                index++;
                return section;
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

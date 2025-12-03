import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  final String userId;

  const DashboardPage({super.key, required this.userId});

  Stream<Map<String, int>> getData() async* {
    final snapshot = await FirebaseFirestore.instance
        .collection('sampah')
        .where('user_id', isEqualTo: userId)
        .get();

    Map<String, int> kategoriCount = {};

    for (var doc in snapshot.docs) {
      String kategori = doc['kategori'];
      kategoriCount[kategori] = (kategoriCount[kategori] ?? 0) + 1;
    }

    yield kategoriCount;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;

        if (data.isEmpty) {
          return const Center(child: Text("Belum ada data grafik"));
        }

        final List<PieChartSectionData> sections = data.entries.map((e) {
          return PieChartSectionData(
            value: e.value.toDouble(),
            title: "${e.key}\n${e.value}",
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Grafik Sampah Per Kategori (Per User)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

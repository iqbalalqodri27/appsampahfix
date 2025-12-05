import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final String userId;

  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();

  // ✅ STREAM DATA PER USER + PER HARI
  Stream<Map<String, int>> getData() async* {
    final startOfDay = Timestamp.fromDate(DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    ));

    final endOfDay = Timestamp.fromDate(DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
      59,
    ));

    final snapshot = await FirebaseFirestore.instance
        .collection('sampah')
        .where('user_id', isEqualTo: widget.userId)
        .where('waktu', isGreaterThanOrEqualTo: startOfDay)
        .where('waktu', isLessThanOrEqualTo: endOfDay)
        .get();

    Map<String, int> kategoriCount = {};

    for (var doc in snapshot.docs) {
      String kategori = doc['kategori'];
      kategoriCount[kategori] = (kategoriCount[kategori] ?? 0) + 1;
    }

    yield kategoriCount;
  }

  // ✅ DATE PICKER
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        /// ✅ FILTER TANGGAL
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tanggal: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text("Pilih"),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Expanded(
          child: StreamBuilder<Map<String, int>>(
            stream: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;
              if (data.isEmpty) {
                return const Center(
                    child: Text("Belum ada data di tanggal ini"));
              }

              /// ✅ PIE CHART DATA
              final pieSections = data.entries.map((e) {
                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: "${e.key}\n${e.value}",
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();

              /// ✅ BAR CHART DATA
              final barGroups = data.entries.toList().asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.value.toDouble(),
                      width: 18,
                    ),
                  ],
                );
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Pie Chart Sampah Per Kategori",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: pieSections,
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Bar Chart Sampah Per Kategori",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          barGroups: barGroups,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final kategori =
                                      data.keys.elementAt(value.toInt());
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      kategori,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

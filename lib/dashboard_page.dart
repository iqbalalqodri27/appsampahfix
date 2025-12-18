import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/api.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  const DashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  Map<String, int> data = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    final tanggal = DateFormat('yyyy-MM-dd').format(selectedDate);
    final url = "${Api.dashboard}/${widget.userId}?date=$tanggal";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List;

        Map<String, int> hasil = {};
        for (var item in jsonData) {
          hasil[item['kategori']] = int.parse(item['total'].toString());
        }

        setState(() {
          data = hasil;
        });
      } else {
        debugPrint("Gagal load dashboard: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error dashboard: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> pilihTanggal() async {
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
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      index++;
      return section;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Sampah"),
        backgroundColor: const Color.fromARGB(255, 42, 139, 196),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// LOGO
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo1.png', width: 200),
              const SizedBox(width: 20),
              // Image.asset('assets/images/logo2.jpg', width: 90),
            ],
          ),

          /// FILTER TANGGAL
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                DateFormat('dd MMM yyyy').format(selectedDate),
              ),
              onPressed: pilihTanggal,
            ),
          ),

          /// GRAFIK
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : data.isEmpty
                    ? const Center(
                        child: Text("Tidak ada data di tanggal ini"),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

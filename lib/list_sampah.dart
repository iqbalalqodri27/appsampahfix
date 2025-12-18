import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'config/api.dart';
import 'detail_sampah_page.dart';
import 'logout.dart';

class ListSampahPage extends StatefulWidget {
  final String userId;
  const ListSampahPage({super.key, required this.userId});

  @override
  State<ListSampahPage> createState() => _ListSampahPageState();
}

class _ListSampahPageState extends State<ListSampahPage> {
  List data = [];
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ================= WARNA CARD BERDASARKAN KATEGORI =================
  Color getKategoriColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case "sampah makanan":
        return Colors.green.shade100;
      case "sampah taman":
        return Colors.lightGreen.shade100;
      case "kayu":
        return Colors.brown.shade100;
      case "kertas karton dan kardus":
        return Colors.orange.shade100;
      case "plastik - lembaran":
        return Colors.blue.shade100;
      case "plastik - kerasan":
        return Colors.blue.shade200;
      case "logam":
        return Colors.grey.shade300;
      case "kain dan produk tekstil":
        return Colors.purple.shade100;
      case "karet dan kulit":
        return Colors.deepOrange.shade100;
      case "kaca":
        return Colors.cyan.shade100;
      case "sampah b3":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // ================= AMBIL DATA =================
  Future<void> fetchData() async {
    setState(() => isLoading = true);

    final tanggal = DateFormat('yyyy-MM-dd').format(selectedDate);
    final url = "${Api.list}/${widget.userId}?date=$tanggal";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        setState(() {
          data = res['data'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetch: $e");
    }

    setState(() => isLoading = false);
  }

  // ================= PILIH TANGGAL =================
  Future<void> pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      fetchData();
    }
  }

  // ================= DELETE DATA =================
  Future<void> deleteData(String id) async {
    try {
      final response =
          await http.delete(Uri.parse("${Api.baseUrl}/sampah/$id"));

      if (response.statusCode == 200) {
        fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Berhasil dihapus")),
        );
      }
    } catch (e) {
      debugPrint("Error delete: $e");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Sampah"),
        backgroundColor: const Color.fromARGB(255, 42, 139, 196),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // ================= LOGO =================
          Image.asset(
            'assets/images/logo1.png',
            width: 200,
          ),

          // ================= FILTER TANGGAL =================
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

          // ================= LIST DATA =================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : data.isEmpty
                    ? const Center(child: Text("Tidak ada data"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final foto = item['foto'] ?? "";
                          final fotoUrl = foto.isNotEmpty ? foto : null;

                          return Card(
                            color: getKategoriColor(item['kategori'] ?? ""),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailSampahPage(data: item),
                                  ),
                                );
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: fotoUrl != null
                                    ? Image.network(
                                        fotoUrl,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image),
                                      )
                                    : Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                            Icons.image_not_supported),
                                      ),
                              ),
                              title: Text(
                                item['nama_sampah'] ?? "-",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['kategori'] ?? "-"),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['waktu'] ?? "",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    deleteData(item['id'].toString()),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

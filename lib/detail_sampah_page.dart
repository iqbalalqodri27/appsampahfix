import 'package:flutter/material.dart';
import 'config/api.dart';
import 'logout.dart';

class DetailSampahPage extends StatelessWidget {
  final Map data;

  const DetailSampahPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final foto = data['foto'] ?? "";
    final fotoUrl = foto.isNotEmpty ? "$foto" : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Sampah"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          )
        ],
        backgroundColor: Color.fromARGB(255, 42, 139, 196),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo1.png', width: 200),
                const SizedBox(width: 30),
                // Image.asset('assets/images/logo2.jpg', width: 90),
              ],
            ),
            // Image.asset('assets/images/logo2.jpg', width: 90),
            // ================== FOTO ==================
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: fotoUrl != null
                    ? Image.network(
                        fotoUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) =>
                            const Icon(Icons.broken_image, size: 100),
                      )
                    : Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 80,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // ================== TITLE ==================
            Center(
              child: Text(
                data['nama_sampah'] ?? "-",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================== DATA DETAIL ==================
            buildDetailItem("Kategori", data['kategori']),
            buildDetailItem("NIS", data['nis']),
            buildDetailItem("Nama", data['nama']),
            buildDetailItem("Kelas", data['kelas']),
            // buildDetailItem("User ID", data['user_id'].toString()),
            buildDetailItem("Waktu", data['waktu'] ?? "-"),
          ],
        ),
      ),
    );
  }

  // ================== WIDGET DETAIL ==================
  Widget buildDetailItem(String title, dynamic value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            value != null ? value.toString() : "-",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

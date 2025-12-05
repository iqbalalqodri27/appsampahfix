import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InputSampahPage extends StatefulWidget {
  final String userId;
  const InputSampahPage({super.key, required this.userId});

  @override
  State<InputSampahPage> createState() => _InputSampahPageState();
}

class _InputSampahPageState extends State<InputSampahPage> {
  final nisnC = TextEditingController();
  final namaC = TextEditingController();
  final kelasC = TextEditingController();
  final namaSampahC = TextEditingController();

  String kategori = "Plastik";

  final List<String> kategoriList = [
    "Plastik",
    "Kertas",
    "Logam",
    "Kaca",
    "Makanan"
  ];

  Future simpanData() async {
    await FirebaseFirestore.instance.collection('sampah').add({
      'user_id': widget.userId,
      'nisn': nisnC.text,
      'nama': namaC.text,
      'kelas': kelasC.text,
      'kategori': kategori,
      'nama_sampah': namaSampahC.text,
      'waktu': DateTime.now(),
    });

    nisnC.clear();
    namaC.clear();
    kelasC.clear();
    namaSampahC.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data berhasil disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
              controller: nisnC,
              decoration: const InputDecoration(labelText: "NISN")),
          TextField(
              controller: namaC,
              decoration: const InputDecoration(labelText: "Nama")),
          TextField(
              controller: kelasC,
              decoration: const InputDecoration(labelText: "Kelas")),
          DropdownButtonFormField<String>(
            value: kategori,
            items: kategoriList
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => kategori = val!),
            decoration: const InputDecoration(labelText: "Kategori"),
          ),
          TextField(
              controller: namaSampahC,
              decoration: const InputDecoration(labelText: "Nama Sampah")),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: simpanData, child: const Text("Simpan"))
        ],
      ),
    );
  }
}

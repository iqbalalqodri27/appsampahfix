import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputSampahPage extends StatefulWidget {
  final String userId;

  const InputSampahPage({super.key, required this.userId});

  @override
  State<InputSampahPage> createState() => _InputSampahPageState();
}

class _InputSampahPageState extends State<InputSampahPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nisnController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController namaSampahController = TextEditingController();

  String? kategoriSampah;

  final List<String> kategoriList = [
    'Sampah Makanan',
    'Sampah Taman',
    'Kayu',
    'Kertas & Kardus',
    'Plastik Lembaran',
    'Plastik Keras',
    'Logam',
    'Kain & Tekstil',
    'Karet & Kulit',
    'Kaca',
    'Sampah B3',
  ];

  // ✅ SIMPAN KE FIRESTORE
  Future<void> simpanData() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("sampah").add({
        'user_id': widget.userId,
        'nisn': nisnController.text,
        'nama': namaController.text,
        'kelas': kelasController.text,
        'kategori': kategoriSampah,
        'nama_sampah': namaSampahController.text,
        'waktu': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil disimpan ✅")),
      );

      nisnController.clear();
      namaController.clear();
      kelasController.clear();
      namaSampahController.clear();

      setState(() {
        kategoriSampah = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Input Sampah")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nisnController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "NISN",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "NISN wajib diisi" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: kelasController,
                decoration: InputDecoration(
                  labelText: "Kelas",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Kelas wajib diisi" : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: kategoriSampah,
                hint: Text("Pilih Kategori Sampah"),
                items: kategoriList.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    kategoriSampah = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Kategori wajib dipilih" : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: namaSampahController,
                decoration: InputDecoration(
                  labelText: "Nama Sampah",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama sampah wajib diisi" : null,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: simpanData,
                  child: Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

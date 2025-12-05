import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputSampahPage extends StatefulWidget {
  final String userId;
  const InputSampahPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<InputSampahPage> createState() => _InputSampahPageState();
}

class _InputSampahPageState extends State<InputSampahPage> {
  final _formKey = GlobalKey<FormState>();

  final nisnController = TextEditingController();
  final namaController = TextEditingController();
  final kelasController = TextEditingController();
  final namaSampahController = TextEditingController();

  String? kategori;

  final List<String> kategoriList = [
    'Plastik',
    'Kertas',
    'Logam',
    'Kaca',
    'Organik',
  ];

  bool isLoading = false;

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection('sampah').add({
      'user_id': widget.userId,
      'nisn': nisnController.text,
      'nama': namaController.text,
      'kelas': kelasController.text,
      'kategori': kategori,
      'nama_sampah': namaSampahController.text,
      'waktu': Timestamp.now(),
    });

    nisnController.clear();
    namaController.clear();
    kelasController.clear();
    namaSampahController.clear();
    kategori = null;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Data berhasil disimpan")),
    );
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.delete_outline, size: 80, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  "Input Data Sampah",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nisnController,
                  decoration: inputStyle("NISN", Icons.badge),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "NISN wajib diisi" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: namaController,
                  decoration: inputStyle("Nama", Icons.person),
                  validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: kelasController,
                  decoration: inputStyle("Kelas", Icons.class_),
                  validator: (v) => v!.isEmpty ? "Kelas wajib diisi" : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: kategori,
                  hint: const Text("Pilih Kategori Sampah"),
                  decoration: inputStyle("Kategori", Icons.category),
                  items: kategoriList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() => kategori = v);
                  },
                  validator: (v) => v == null ? "Kategori wajib dipilih" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: namaSampahController,
                  decoration: inputStyle("Nama Sampah", Icons.delete_sweep),
                  validator: (v) =>
                      v!.isEmpty ? "Nama sampah wajib diisi" : null,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("SIMPAN DATA"),
                    onPressed: isLoading ? null : simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

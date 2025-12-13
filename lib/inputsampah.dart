import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'config/api.dart';
import 'logout.dart';

class InputSampahPage extends StatefulWidget {
  final String userId;
  const InputSampahPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<InputSampahPage> createState() => _InputSampahPageState();
}

class _InputSampahPageState extends State<InputSampahPage> {
  final _formKey = GlobalKey<FormState>();

  final nisController = TextEditingController();
  final namaController = TextEditingController();
  final kelasController = TextEditingController();
  final namaSampahController = TextEditingController();

  String? kategori;
  File? foto;

  bool isLoading = false;

  final picker = ImagePicker();

  final List<String> kategoriList = [
    "Sampah Makanan",
    "Sampah Taman",
    "Kayu",
    "Kertas Karton dan Kardus",
    "Plastik - Lembaran",
    "Plastik - Kerasan",
    "Logam",
    "Kain dan Produk Tekstil",
    "Karet dan Kulit",
    "Kaca",
    "Sampah B3",
  ];

  // ================== PILIH FOTO ==================
  Future<void> pilihFoto(ImageSource source) async {
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 75,
    );

    if (picked != null) {
      setState(() {
        foto = File(picked.path);
      });
    }
  }

  // ================== SIMPAN KE LARAVEL ==================
  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;
    if (foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(Api.sampahStore),
      );

      request.fields.addAll({
        "user_id": widget.userId,
        "nis": nisController.text,
        "nama": namaController.text,
        "kelas": kelasController.text,
        "kategori": kategori!,
        "nama_sampah": namaSampahController.text,
        "waktu": DateTime.now().toIso8601String(),
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "foto",
          foto!.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        nisController.clear();
        namaController.clear();
        kelasController.clear();
        namaSampahController.clear();
        setState(() {
          kategori = null;
          foto = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Data berhasil disimpan")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Gagal menyimpan data")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Gagal terhubung ke server")),
      );
    }

    setState(() => isLoading = false);
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.delete_outline,
                      size: 80, color: Colors.green),
                  const Text(
                    "Input Data Sampah",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nisController,
                    decoration: inputStyle("NIS", Icons.badge),
                    validator: (v) => v!.isEmpty ? "NIS wajib diisi" : null,
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
                    decoration: inputStyle("Kategori", Icons.category),
                    items: kategoriList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => kategori = v),
                    validator: (v) =>
                        v == null ? "Kategori wajib dipilih" : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: namaSampahController,
                    decoration: inputStyle("Nama Sampah", Icons.delete_sweep),
                    validator: (v) =>
                        v!.isEmpty ? "Nama sampah wajib diisi" : null,
                  ),
                  const SizedBox(height: 20),

                  // FOTO PREVIEW
                  foto == null
                      ? const Text("Belum ada foto")
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            foto!,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Kamera"),
                        onPressed: () => pilihFoto(ImageSource.camera),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text("Galeri"),
                        onPressed: () => pilihFoto(ImageSource.gallery),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SIMPAN DATA"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class EditSampahPage extends StatefulWidget {
//   final String id;
//   final Map<String, dynamic> data;
//   const EditSampahPage({required this.id, required this.data, super.key});

//   @override
//   State<EditSampahPage> createState() => _EditSampahPageState();
// }

// class _EditSampahPageState extends State<EditSampahPage> {
//   late TextEditingController nisController;
//   late TextEditingController kelasController;
//   late TextEditingController namaController;
//   late TextEditingController namaSampahController;
//   String? kategori;

//   final List<String> listKategori = [
//     "Sampah Makanan",
//     "Sampah Taman",
//     "Kayu",
//     "Kertas",
//     "Karton & Kardus",
//     "Plastik - Lembaran",
//     "Plastik - Kerasan",
//     "Logam",
//     "Kain & Produk Tekstil",
//     "Karet & Kulit",
//     "Kaca",
//     "Sampah B3",
//   ];

//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     nisController = TextEditingController(text: widget.data['nis'] ?? '');
//     kelasController = TextEditingController(text: widget.data['kelas'] ?? '');
//     namaController = TextEditingController(text: widget.data['nama'] ?? '');
//     namaSampahController = TextEditingController(
//       text: widget.data['nama_sampah'] ?? '',
//     );
//     kategori = widget.data['kategori'];
//   }

//   @override
//   void dispose() {
//     nisController.dispose();
//     kelasController.dispose();
//     namaController.dispose();
//     namaSampahController.dispose();
//     super.dispose();
//   }

//   Future<void> _update() async {
//     if (nisController.text.isEmpty ||
//         kelasController.text.isEmpty ||
//         namaController.text.isEmpty ||
//         kategori == null ||
//         namaSampahController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Lengkapi input'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     setState(() => loading = true);
//     await FirebaseFirestore.instance
//         .collection('sampah')
//         .doc(widget.id)
//         .update({
//       'nis': nisController.text.trim(),
//       'kelas': kelasController.text.trim(),
//       'nama': namaController.text.trim(),
//       'kategori': kategori,
//       'nama_sampah': namaSampahController.text.trim(),
//     });
//     setState(() => loading = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Data diperbarui'),
//         backgroundColor: Colors.green,
//       ),
//     );
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Data'),
//         backgroundColor: const Color(0xFF800020),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 controller: nisController,
//                 decoration: const InputDecoration(labelText: 'NIS'),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: kelasController,
//                 decoration: const InputDecoration(labelText: 'Kelas'),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: namaController,
//                 decoration: const InputDecoration(labelText: 'Nama'),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 initialValue: kategori,
//                 decoration: const InputDecoration(labelText: 'Kategori'),
//                 items: listKategori
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (v) => setState(() => kategori = v),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: namaSampahController,
//                 decoration: const InputDecoration(labelText: 'Nama Sampah'),
//               ),
//               const SizedBox(height: 18),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: loading ? null : _update,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF800020),
//                   ),
//                   child: loading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Update'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

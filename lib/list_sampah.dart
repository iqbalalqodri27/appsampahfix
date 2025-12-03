import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListSampahPage extends StatelessWidget {
  final String userId;
  const ListSampahPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Data Sampah")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("sampah")
            .where('user_id', isEqualTo: userId) // ✅ FILTER PER USER
            .orderBy('waktu', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Belum ada data"));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(doc['nama']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("NISN : ${doc['nisn']}"),
                      Text("Kelas : ${doc['kelas']}"),
                      Text("Kategori : ${doc['kategori']}"),
                      Text("Nama Sampah : ${doc['nama_sampah']}"),
                    ],
                  ),

                  // ✅ TOMBOL EDIT & HAPUS
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigator.push(context
                          //     // MaterialPageRoute(
                          //     //   // builder: (_) => EditSampahPage(
                          //     //   //   docId: doc.id,
                          //     //   //   data: doc,
                          //     //   // ),
                          //     // ),
                          //     );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("sampah")
                              .doc(doc.id)
                              .delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Data berhasil dihapus")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

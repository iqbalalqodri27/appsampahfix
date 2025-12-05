import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportPdf(String userId) async {
  final pdf = pw.Document();

  final data = await FirebaseFirestore.instance
      .collection('sampah')
      .where('user_id', isEqualTo: userId)
      .get();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          children: data.docs.map((doc) {
            return pw.Text(
                "${doc['nama']} - ${doc['kategori']} - ${doc['jumlah']}");
          }).toList(),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}

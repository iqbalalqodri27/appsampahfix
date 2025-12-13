import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class SampahService {
  static Future<bool> upload({
    required String userId,
    required String nisn,
    required String nama,
    required String kelas,
    required String kategori,
    required String namaSampah,
    required String waktu,
    File? foto,
  }) async {
    var url = Uri.parse(Api.sampahStore);

    var request = http.MultipartRequest("POST", url);

    request.fields['user_id'] = userId;
    request.fields['nisn'] = nisn;
    request.fields['nama'] = nama;
    request.fields['kelas'] = kelas;
    request.fields['kategori'] = kategori;
    request.fields['nama_sampah'] = namaSampah;
    request.fields['waktu'] = waktu;

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();

    print("UPLOAD RESPONSE: $respStr");

    return response.statusCode == 200;
  }
}

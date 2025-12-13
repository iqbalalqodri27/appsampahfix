import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../auth/login_page.dart';
import 'login_page.dart';

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // hapus semua penyimpanan user

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginRegisterPage()),
    (Route<dynamic> route) => false,
  );
}

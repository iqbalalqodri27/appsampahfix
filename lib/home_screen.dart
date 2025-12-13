import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil token, TIDAK boleh salah tipe
    String? token = prefs.getString("token");

    Future.delayed(Duration(seconds: 2), () {
      if (token != null && token!.isNotEmpty) {
        // Token ditemukan → redirect ke halaman input
        Navigator.pushReplacementNamed(context, '/input');
      } else {
        // Token tidak ada → redirect ke login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

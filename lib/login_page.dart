import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  // =========================
  //          LOGIN
  // =========================
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showError("Email & Password wajib diisi");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(Api.login),
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      var data = json.decode(response.body);
      print("LOGIN RESPONSE: $data");

      if (response.statusCode == 200 && data["user"] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", data["user"]["id"].toString());

        Navigator.pushReplacementNamed(
          context,
          "/home",
          arguments: data["user"]["id"].toString(),
        );
      } else {
        showError(data["message"] ?? "Login gagal");
      }
    } catch (e) {
      showError("Tidak dapat terhubung ke server");
    }

    setState(() => isLoading = false);
  }

  // =========================
  //        REGISTER
  // =========================
  Future<void> register() async {
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showError("Semua field wajib diisi");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(Api.register),
        body: {
          "name": namaController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      var data = json.decode(response.body);
      print("REGISTER RESPONSE: $data");

      if (response.statusCode == 200 && data["user"] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", data["user"]["id"].toString());

        Navigator.pushReplacementNamed(
          context,
          "/home",
          arguments: data["user"]["id"].toString(),
        );
      } else {
        showError(data["message"] ?? "Register gagal");
      }
    } catch (e) {
      showError("Tidak dapat terhubung ke server");
    }

    setState(() => isLoading = false);
  }

  // =========================
  //        ERROR MSG
  // =========================
  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // =========================
  //          UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/images/logo1.png', width: 400),
              const SizedBox(width: 20),
              Icon(Icons.person, size: 80, color: Colors.blue),
              SizedBox(height: 20),
              Text(isLogin ? "LOGIN" : "REGISTER",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              if (!isLogin)
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                      labelText: "Nama Lengkap", border: OutlineInputBorder()),
                ),
              if (!isLogin) SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              ),
              SizedBox(height: 25),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: isLogin ? login : register,
                      child: Text(isLogin ? "LOGIN" : "REGISTER"),
                    ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin
                    ? "Belum punya akun? Daftar"
                    : "Sudah punya akun? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

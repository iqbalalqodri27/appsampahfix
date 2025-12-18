import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final passwordLama = TextEditingController();
  final passwordBaru = TextEditingController();
  final konfirmasiPassword = TextEditingController();

  bool isLoading = false;

  // =================== GANTI PASSWORD ===================
  Future<void> gantiPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/change-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": widget.userId,
          "password_lama": passwordLama.text,
          "password_baru": passwordBaru.text,
        }),
      );

      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Password berhasil diubah")),
        );

        passwordLama.clear();
        passwordBaru.clear();
        konfirmasiPassword.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Gagal ganti password")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Gagal terhubung ke server")),
      );
    }

    setState(() => isLoading = false);
  }

  // =================== LOGOUT ===================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginRegisterPage()),
      (route) => false,
    );
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // =================== UI ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: const Color.fromARGB(255, 42, 139, 196),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person, size: 90, color: Colors.blue),
                  const SizedBox(height: 10),
                  const Text(
                    "Ganti Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordLama,
                    obscureText: true,
                    decoration: inputStyle("Password Lama", Icons.lock),
                    validator: (v) =>
                        v!.isEmpty ? "Password lama wajib diisi" : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: passwordBaru,
                    obscureText: true,
                    decoration: inputStyle("Password Baru", Icons.lock_outline),
                    validator: (v) =>
                        v!.length < 6 ? "Minimal 6 karakter" : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: konfirmasiPassword,
                    obscureText: true,
                    decoration:
                        inputStyle("Konfirmasi Password", Icons.lock_reset),
                    validator: (v) =>
                        v != passwordBaru.text ? "Password tidak sama" : null,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : gantiPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("GANTI PASSWORD"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        "LOGOUT",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: logout,
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

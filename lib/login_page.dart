import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart'; // untuk menuju ke MyApp (menu utama)

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  void login() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyApp()),
      );
    } catch (e) {
      showError(e.toString());
    }
    setState(() => isLoading = false);
  }

  void register() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyApp()),
      );
    } catch (e) {
      showError(e.toString());
    }
    setState(() => isLoading = false);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ 2 LOGO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo1.jpg', width: 70),
                  const SizedBox(width: 20),
                  Image.asset('assets/images/logo2.jpg', width: 70),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                isLogin ? "LOGIN" : "REGISTER",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              if (!isLogin)
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                ),

              if (!isLogin) const SizedBox(height: 15),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLogin ? login : register,
                        child: Text(isLogin ? "LOGIN" : "REGISTER"),
                      ),
                    ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  setState(() => isLogin = !isLogin);
                },
                child: Text(
                  isLogin
                      ? "Belum punya akun? Daftar"
                      : "Sudah punya akun? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

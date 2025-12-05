import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'inputsampah.dart';
import 'list_sampah.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainRouter());
}

// =====================
// MAIN ROUTER
// =====================
class MainRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catat Sampahmu',
      home: SplashScreenPage(),
    );
  }
}

// =====================
// SPLASH SCREEN
// =====================
class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.recycling, color: Colors.white, size: 100),
            SizedBox(height: 20),
            Text(
              "Catat Sampahmu",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// MAIN PAGE SETELAH LOGIN
// =====================
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  User? user;
  late List<Widget> _pages;

  final List<String> _titles = ["Input Data", "List Data", "Dashboard Grafik"];

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _pages = const [
        Center(child: Text("User belum login")),
        Center(child: Text("User belum login")),
        Center(child: Text("User belum login")),
      ];
    } else {
      _pages = [
        InputSampahPage(userId: user!.uid),
        ListSampahPage(userId: user!.uid),
        DashboardPage(userId: user!.uid), // ✅ KONSISTEN SEMUA PAKE UID
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginRegisterPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[300],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.input), label: "Form Input Sampah"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "List Data Sampah"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
        ],
      ),
    );
  }
}

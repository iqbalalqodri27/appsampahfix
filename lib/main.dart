import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';

import 'inputsampah.dart';
import 'list_sampah.dart';
import 'dashboard_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 42, 139, 196),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 42, 139, 196),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginRegisterPage(),
        '/home': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(userId: userId);
        },
      },
    );
  }
}

// ===========================
//       SPLASH SCREEN
// ===========================
class SplashScreen extends StatefulWidget {
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

    // user_id bisa int atau string
    String? userId =
        prefs.getString("user_id") ?? prefs.getInt("user_id")?.toString();

    await Future.delayed(Duration(seconds: 1));

    if (!mounted) return;

    if (userId != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: userId);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ===========================
//        HOME PAGE
// ===========================
class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      InputSampahPage(userId: widget.userId),
      ListSampahPage(userId: widget.userId),
      DashboardPage(userId: widget.userId),
      ProfilePage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 42, 139, 196), // WARNA BAR
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Input"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

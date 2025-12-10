import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';

// --- IMPORT PROVIDER ---
import 'providers/auth_provider.dart';
import 'providers/activity_provider.dart'; // <--- Pastikan ini ada

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Konek ke Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GoFitApp());
}

// --- PERBAIKAN: CLASS DI KEMBALIKAN ---
class GoFitApp extends StatelessWidget {
  const GoFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Provider Auth (Login)
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLoginStatus(),
        ),

        // 2. Provider Activity (Hitung Kalori & Simpan Data)
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'GoFit App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF00E676),
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00E676),
            secondary: Color(0xFF00C853),
            surface: Color(0xFF1E1E1E),
          ),
          useMaterial3: true,
        ),
        // SEMENTARA: Masih pakai Cek Koneksi (Nanti diganti Anggota B)
        home: const CekKoneksiScreen(),
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

// --- LAYAR TESTING ---
class CekKoneksiScreen extends StatelessWidget {
  const CekKoneksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GoFit System Check"),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              "BACKEND READY!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Auth & Activity Provider Terdaftar.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
// --- OTAK APLIKASI (PROVIDER) ---
class AuthProvider with ChangeNotifier {
  String _userName = "Runner"; // Nama Default

  String get userName => _userName;

  // Fungsi simpan nama dari Sign Up
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// --- BAGIAN 1: SETTINGAN AWAL ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INI KUNCINYA: Menghubungkan aplikasi ke JSON yang tadi kamu pasang
  await Firebase.initializeApp();

  runApp(const GoFitApp());
}

class GoFitApp extends StatelessWidget {
  const GoFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Nanti logic Login & Data ditaruh di sini
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'GoFit App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // --- TEMA GOFIT (HIJAU & HITAM) ---
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
        // Saat aplikasi dibuka, langsung cek status koneksi
        home: const CekKoneksiScreen(),
      ),
    );
  }
}

// --- BAGIAN 2: LOGIC SEMENTARA (Supaya tidak error merah) ---
class AuthProvider with ChangeNotifier {
  // Nanti diisi logika Login beneran oleh Person A
  void login() {
    print("Login diproses...");
    notifyListeners();
  }
}

// --- BAGIAN 3: LAYAR PENGECEKAN (Supaya kamu yakin berhasil) ---
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
            // Ikon Centang Besar
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),

            // Tulisan Status
            const Text(
              "FIREBASE TERHUBUNG!",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sekarang tim bisa mulai bagi tugas.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Import Provider Asli yang baru dibuat
import 'providers/auth_provider.dart';
// Import Halaman Login (Nanti ini diisi Anggota B, sementara error/merah gpp atau di komen dulu)
// import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GoFitApp());
}

class GoFitApp extends StatelessWidget {
  const GoFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Panggil AuthProvider yang ASLI (bukan dummy lagi)
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkLoginStatus()),
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
        // SEMENTARA MASIH PAKAI CEK KONEKSI
        // Nanti Anggota B yang akan mengubah ini jadi LoginScreen()
        home: const CekKoneksiScreen(),
      ),
    );
  }
}

// Class CekKoneksiScreen biarkan saja di bawah sini sebagai placeholder
class CekKoneksiScreen extends StatelessWidget {
  const CekKoneksiScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GoFit System Check"), backgroundColor: Colors.green[800]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text("FIREBASE TERHUBUNG!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("Backend Auth sudah siap.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
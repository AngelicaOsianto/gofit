import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'providers/activity_provider.dart'; // Pastikan ActivityProvider di-import

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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()), // Tambahkan ActivityProvider di sini
      ],
      child: MaterialApp(
        title: 'GoFit App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(), // Splash akan mengarah ke Login/Main
      ),
    );
  }
}

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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/activity_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/page_provider.dart';
import 'screens/splash_screen.dart';

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
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => PageProvider()),
      ],
      child: MaterialApp(
        title: 'GoFit App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

// --- OTAK APLIKASI (AUTH PROVIDER) ---
class AuthProvider with ChangeNotifier {
  String _userName = "Runner";
  String _email = "user@gofit.com";
  String _weight = "60"; // Default
  String _height = "170"; // Default

  // Getters
  String get userName => _userName;
  String get email => _email;
  String get weight => _weight;
  String get height => _height;

  // Fungsi simpan data lengkap saat Register
  void registerUser({
    required String name,
    required String email,
    required String weight,
    required String height,
  }) {
    _userName = name;
    _email = email;
    _weight = weight;
    _height = height;
    notifyListeners();
  }

  // Update nama saja (opsional)
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
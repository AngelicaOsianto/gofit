import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neonGreen,
      body: Center(child: Image.asset(
        'assets/images/Splash.png', // Coba cek lagi, 'Splash.png' atau 'splash.png'?
        width: 150,
        height: 150, // Tambahkan tinggi biar tidak gepeng
        fit: BoxFit.contain, // Pastikan gambar muat di kotak
      ),),
    );
  }
}
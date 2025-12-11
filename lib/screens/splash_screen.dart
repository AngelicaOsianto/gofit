import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import 'auth/register_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.checkAuthStatus();

    if (auth.isAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_run, size: 80, color: AppTheme.neonGreen),
            const SizedBox(height: 20),
            Text("GoFit", style: TextStyle(fontSize: 40, color: AppTheme.neonGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CircularProgressIndicator(color: AppTheme.neonGreen),
          ],
        ),
      ),
    );
  }
}
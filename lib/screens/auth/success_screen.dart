import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../core/theme.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: AppTheme.neonGreen),
            const SizedBox(height: 20),
            const Text("Success!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
              child: const Text("Go Home", style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}
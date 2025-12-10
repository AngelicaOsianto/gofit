import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../home/home_screen.dart';
import '../home_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.darkGreen, Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(), const Icon(Icons.check_circle_outline, size: 120, color: Colors.white),
          const SizedBox(height: 30), const Text("Ready to Explore!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(), ElevatedButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (r) => false), child: const Text("Next"))
        ]))),
      ),
    );
  }
}
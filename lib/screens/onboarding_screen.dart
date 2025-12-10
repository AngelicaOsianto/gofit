import 'package:flutter/material.dart';
import 'auth/sign_up_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(width: double.infinity, height: double.infinity, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Start.jpg'), fit: BoxFit.cover))),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)], stops: const [0.5, 1.0]))),
          SafeArea(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Text("Rebuild\nYourself!", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)), const SizedBox(height: 40), ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen())), child: const Text("Start")), const SizedBox(height: 20)]))),
        ],
      ),
    );
  }
}
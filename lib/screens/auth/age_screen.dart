import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'weight_screen.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});
  @override
  State<AgeScreen> createState() => _AgeScreenState();
}
class _AgeScreenState extends State<AgeScreen> {
  int age = 22;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.darkGreen, AppTheme.blackBg], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Column(children: [
          const SizedBox(height: 40), const Text("What is your age?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          Text("$age", style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)),
          Slider(value: age.toDouble(), min: 10, max: 80, activeColor: AppTheme.neonGreen, onChanged: (v) => setState(() => age = v.toInt())),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(24), child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WeightScreen())), child: const Text("Continue")))
        ])),
      ),
    );
  }
}
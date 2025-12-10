import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'success_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});
  @override
  State<WeightScreen> createState() => _WeightScreenState();
}
class _WeightScreenState extends State<WeightScreen> {
  int weight = 75;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.darkGreen, AppTheme.blackBg], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Column(children: [
          const SizedBox(height: 40), const Text("What is your weight?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          Text("$weight KG", style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)),
          Slider(value: weight.toDouble(), min: 30, max: 150, activeColor: AppTheme.neonGreen, onChanged: (v) => setState(() => weight = v.toInt())),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(24), child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessScreen())), child: const Text("Continue")))
        ])),
      ),
    );
  }
}
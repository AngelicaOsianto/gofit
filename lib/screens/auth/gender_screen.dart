import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'age_screen.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});
  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  bool isMale = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.darkGreen, AppTheme.blackBg], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Column(children: [
          const SizedBox(height: 40), const Text("What is your gender?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(), Row(mainAxisAlignment: MainAxisAlignment.center, children: [_btn("Male", Icons.male, true), const SizedBox(width: 30), _btn("Female", Icons.female, false)]),
          const Spacer(), Padding(padding: const EdgeInsets.all(24), child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AgeScreen())), child: const Text("Continue")))
        ])),
      ),
    );
  }
  Widget _btn(String l, IconData i, bool v) => GestureDetector(onTap: () => setState(() => isMale = v), child: Column(children: [Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: isMale == v ? AppTheme.neonGreen : Colors.transparent, border: Border.all(color: isMale == v ? AppTheme.neonGreen : Colors.grey, width: 2)), child: Icon(i, size: 60, color: isMale == v ? Colors.black : Colors.white)), const SizedBox(height: 10), Text(l, style: TextStyle(color: isMale == v ? AppTheme.neonGreen : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold))]));
}
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../home/home_screen.dart';
import '../home_screen.dart';
import '../main_screen.dart'; // Mengarah ke Main Screen (Dashboard)

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
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [AppTheme.darkGreen, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Icon(Icons.check_circle_outline, size: 120, color: Colors.white),
                      const SizedBox(height: 30),
                      const Text(
                        "Registration Successful!",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You are ready to start your journey.",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),

                      // Tombol Lanjut ke Dashboard (MainScreen)
                      ElevatedButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MainScreen()),
                                  (r) => false
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                          child: const Text("Go to Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                      )
                    ]
                )
            )
        ),
      ),
    );
  }
}
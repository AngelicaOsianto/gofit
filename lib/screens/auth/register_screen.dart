import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../main.dart'; // Untuk akses AuthProvider
import 'login_screen.dart';
import 'success_screen.dart'; // Navigasi setelah sukses daftar

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Gradient Hijau-Hitam
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.darkGreen, AppTheme.blackBg],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                // Tombol Back
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),
                const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text("Join us and challenge your limits!", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 30),

                // --- FORM INPUT ---

                // 1. Full Name
                Align(alignment: Alignment.centerLeft, child: _lbl("Full Name")),
                _in("Enter your full name", _nameController),
                const SizedBox(height: 15),

                // 2. Email
                Align(alignment: Alignment.centerLeft, child: _lbl("Email or Username")),
                _in("Enter your email", _emailController),
                const SizedBox(height: 15),

                // 3. Password (Gabungan dari CreatePassword)
                Align(alignment: Alignment.centerLeft, child: _lbl("Password")),
                Container(
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: _isObscure,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Create a password",
                      hintStyle: const TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white60),
                          onPressed: () => setState(() => _isObscure = !_isObscure)
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // TOMBOL REGISTER
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      // 1. Simpan Nama ke Provider
                      Provider.of<AuthProvider>(context, listen: false).setUserName(_nameController.text);

                      // 2. Pindah ke Halaman Sukses
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SuccessScreen())
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your name")));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 30),

                // Link ke Login
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Already have an account? ", style: TextStyle(color: Colors.white)),
                  GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      child: const Text("Log In", style: TextStyle(color: AppTheme.neonGreen, fontWeight: FontWeight.bold))
                  )
                ]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Label dan Input
  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));

  Widget _in(String h, TextEditingController c) => Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: TextField(
          controller: c,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white60), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))
      )
  );
}
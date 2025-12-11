import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import 'gender_screen.dart';
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
            padding: const EdgeInsets.all(24.0),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
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


                _buildLabel("Email"),
                _buildInput("Enter your email", _emailController),
                // 1. Full Name
                Align(alignment: Alignment.centerLeft, child: _lbl("Full Name")),
                _in("Enter your full name", _nameController),
                const SizedBox(height: 15),

                // 2. Email
                Align(alignment: Alignment.centerLeft, child: _lbl("Email or Username")),
                _in("Enter your email", _emailController),
                const SizedBox(height: 15),

                _buildLabel("Password"),
                // 3. Password (Gabungan dari CreatePassword)
                Align(alignment: Alignment.centerLeft, child: _lbl("Password")),
                Container(
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: _isObscure,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      hintText: "Create a password",
                      hintStyle: const TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white60),
                        onPressed: () => setState(() => _isObscure = !_isObscure),
                          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white60),
                          onPressed: () => setState(() => _isObscure = !_isObscure)
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // TOMBOL CONTINUE
                // TOMBOL REGISTER
                ElevatedButton(
                  onPressed: () {
                    String fullName = _nameController.text;
                    if (fullName.isEmpty) fullName = "Runner";
                    Provider.of<AuthProvider>(context, listen: false).setUserName(fullName);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GenderScreen()));
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
                  child: const Text("Continue"),
                ),

                const SizedBox(height: 20),

                // --- PEMBATAS OR ---
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or", style: TextStyle(color: Colors.white)),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 20),

                // --- TOMBOL GOOGLE (BARU) ---
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Sign in with Google", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
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

  Widget _buildLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
  Widget _buildInput(String h, TextEditingController c) => Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: TextField(controller: c, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white60), border: InputBorder.none, contentPadding: const EdgeInsets.all(16))));
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
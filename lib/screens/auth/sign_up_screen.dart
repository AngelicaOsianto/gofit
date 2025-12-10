import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../core/theme.dart';
import 'gender_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.darkGreen, AppTheme.blackBg], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(child: Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))),
                const SizedBox(height: 30),
                _lbl("Full Name"), _in("Enter your full name", _nameController),
                const SizedBox(height: 20),
                _lbl("Email"), _in("Enter your email", _emailController),
                const SizedBox(height: 20),
                _lbl("Password"),
                Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: TextField(controller: _passController, obscureText: _isObscure, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Enter password", hintStyle: const TextStyle(color: Colors.white60), border: InputBorder.none, contentPadding: const EdgeInsets.all(16), suffixIcon: IconButton(icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white60), onPressed: () => setState(() => _isObscure = !_isObscure))))),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // 1. Simpan Nama ke Provider
                    String name = _nameController.text.isEmpty ? "Runner" : _nameController.text;
                    Provider.of<AuthProvider>(context, listen: false).setUserName(name);

                    // 2. Lanjut ke Gender
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GenderScreen()));
                  },
                  child: const Text("Sign Up"),
                ),
                const SizedBox(height: 30),
                Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Already have an account? ", style: TextStyle(color: Colors.white)), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())), child: const Text("Log In", style: TextStyle(color: AppTheme.neonGreen, fontWeight: FontWeight.bold)))])),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
  Widget _in(String h, TextEditingController c) => Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: TextField(controller: c, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white60), border: InputBorder.none, contentPadding: const EdgeInsets.all(16))));
}
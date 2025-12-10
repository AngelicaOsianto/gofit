import 'package:flutter/material.dart';
import '../../core/theme.dart';           // Mundur ke core
import '../home/home_screen.dart';
import '../home_screen.dart';        // Mundur ke home

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.darkGreen, AppTheme.blackBg],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Create Password",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),

                _buildLabel("Password"),
                _buildPasswordField("Enter your password", _passController),
                const SizedBox(height: 20),

                _buildLabel("Confirm Password"),
                _buildPasswordField("Confirm your password", _confirmController),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    // Pindah ke Home dan hapus riwayat login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                    );
                  },
                  child: const Text("Create Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: _isObscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white60),
            onPressed: () => setState(() => _isObscure = !_isObscure),
          ),
        ),
      ),
    );
  }
}
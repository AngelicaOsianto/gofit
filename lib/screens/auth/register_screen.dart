import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth_package;
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import 'success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.darkGreen, AppTheme.blackBg],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 30),
                _in("Full Name", _nameController),
                const SizedBox(height: 15),
                _in("Email", _emailController),
                const SizedBox(height: 15),
                _passInput(),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _in("Weight (Kg)", _weightController, isNum: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _in("Height (Cm)", _heightController, isNum: true)),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen, padding: const EdgeInsets.all(16)),
                    onPressed: () async {
                      try {
                        await auth.registerUser(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passController.text,
                          weight: _weightController.text,
                          height: _heightController.text,
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                    child: const Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _in(String hint, TextEditingController c, {bool isNum = false}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
    child: TextField(
      controller: c, keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none),
    ),
  );

  Widget _passInput() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
    child: TextField(
      controller: _passController, obscureText: _isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Password", border: InputBorder.none,
        suffixIcon: IconButton(icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _isObscure = !_isObscure)),
      ),
    ),
  );
}
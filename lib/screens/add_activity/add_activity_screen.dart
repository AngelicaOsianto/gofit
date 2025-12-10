import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AddActivityScreen extends StatelessWidget {
  const AddActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBg,
      appBar: AppBar(title: const Text("Add Activity", style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: const Center(child: Text("Form Tambah Olahraga", style: TextStyle(color: Colors.white))),
    );
  }
}
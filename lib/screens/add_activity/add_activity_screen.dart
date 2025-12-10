import 'package:flutter/material.dart';
import '../../core/theme.dart';

//Nama class ini harus persis "AddActivityScreen"
class AddActivityScreen extends StatelessWidget {
  const AddActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBg,
      appBar: AppBar(title: const Text("Add Activity", style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: const Center(child: Text("Add activity", style: TextStyle(color: Colors.white))),
    );
  }
}
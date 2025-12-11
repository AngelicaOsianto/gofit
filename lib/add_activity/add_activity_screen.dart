//TODO Implement this library.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_provider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  // Variabel untuk menampung input user
  String? _selectedActivity;
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _weightController = TextEditingController(text: "60"); // Default berat badan 60kg

  @override
  Widget build(BuildContext context) {
    // Panggil Provider Activity untuk akses daftar olahraga & fungsi simpan
    final activityProvider = Provider.of<ActivityProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Ambil daftar nama olahraga dari Kamus MET yang sudah Anda buat di Provider
    final List<String> activityList = activityProvider.metValues.keys.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add New Activity", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Activity", style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 10),

            // 1. DROPDOWN OLAHRAGA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedActivity,
                  hint: const Text("Select Activity", style: TextStyle(color: Colors.grey)),
                  dropdownColor: const Color(0xFF1E1E1E),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: activityList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedActivity = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Duration (minutes)", style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 10),

            // 2. INPUT DURASI
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ex: 30",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Your Weight (kg)", style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 10),

            // 3. INPUT BERAT BADAN (Penting untuk rumus MET)
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ex: 65",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 40),

            // 4. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676), // Hijau Neon
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: activityProvider.isLoading
                    ? null // Matikan tombol kalau lagi loading
                    : () async {
                  if (_selectedActivity == null || _durationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields!"))
                    );
                    return;
                  }

                  // PANGGIL FUNGSI BACKEND ANDA!
                  try {
                    await activityProvider.addActivity(
                      userId: authProvider.user?.uid ?? "guest_id", // Ambil ID user asli
                      activityName: _selectedActivity!,
                      durationMinutes: double.parse(_durationController.text),
                      weightKg: double.parse(_weightController.text),
                    );

                    if (context.mounted) {
                      Navigator.pop(context); // Kembali ke Home
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Activity Saved! Calories Calculated! 🔥"))
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e"))
                    );
                  }
                },
                child: activityProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("SAVE ACTIVITY", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
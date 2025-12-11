// TODO Implement this library.import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../core/theme.dart';
import '../../services/weather_service.dart';
import '../../providers/activity_provider.dart'; // Import Provider
import '../../models/activity_model.dart'; // Import Model
import '../activity/activity_list_screen.dart'; // Import untuk navigasi "See Activity"
import '../main_screen.dart'; // Import MainScreen untuk akses navigasi navbar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Variabel Cuaca ---
  String temp = "0";
  String desc = "Loading...";
  String cityName = "Gowa";
  String iconCode = "01d";

  // --- Variabel Jam ---
  String _timeString = "00:00";
  String _dateString = "";
  late Timer _timer;
  final _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _startClock();
  }

  @override
  void dispose() {
    if (mounted) _timer.cancel();
    super.dispose();
  }

  void _startClock() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm').format(now);
        _dateString = DateFormat('EEEE, d MMM yyyy').format(now);
      });
    }
  }

  void _fetchWeather() async {
    try {
      final data = await _weatherService.getWeather("Gowa");
      if (mounted) {
        setState(() {
          temp = data['main']['temp'].toStringAsFixed(0);
          desc = data['weather'][0]['main'];
          cityName = data['name'];
          iconCode = data['weather'][0]['icon'];
        });
      }
    } catch (e) {
      debugPrint("Error cuaca: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil Data User
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String firstName = authProvider.userName.split(' ')[0];

    // Ambil Data Activity dari Provider
    final activityProvider = Provider.of<ActivityProvider>(context);
    final activities = activityProvider.activities;
    final recentActivities = activities.take(5).toList(); // Ambil 5 data terbaru

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, $firstName! 👋", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("It's time to challenge your limits", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 2. WEATHER CARD (SESUAI DESAIN HOME (3).PNG)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.neonGreen), // Border Hijau Neon
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bagian Kiri (Lokasi, Cuaca, Jam)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cityName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)),
                      Text(desc, style: const TextStyle(fontSize: 16, color: AppTheme.neonGreen)),
                      const SizedBox(height: 15),
                      Text(_dateString, style: const TextStyle(fontSize: 12, color: Color(0xFFC1FF00))), // Tanggal Kuning
                      Text(_timeString, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)), // Jam Besar Hijau
                    ],
                  ),
                  // Bagian Kanan (Icon & Suhu)
                  Column(
                    children: [
                      Image.network('https://openweathermap.org/img/wn/$iconCode@2x.png', width: 70, height: 70, errorBuilder: (_,__,___) => const Icon(Icons.cloud, color: Colors.white, size: 50)),
                      Text("$temp°C", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. MY PROGRESS
            const Text("My Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.neonGreen), // Border Hijau sesuai desain
                color: Colors.transparent, // Background transparan/hitam
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressItem(Icons.access_time, "Total Duration", "200m"),
                  _buildProgressItem(Icons.local_fire_department, "Total Calories", "350kl"),
                  _buildProgressItem(Icons.directions_run, "Total Activities", "${activities.length} act"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. MY ACTIVITY SECTION (SESUAI DESAIN)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("My Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                // Tombol "See Activity" (Navigasi ke Tab Activity)
                GestureDetector(
                  onTap: () {
                    // Cari MainScreenState dan pindah ke tab index 1
                    final mainState = context.findAncestorStateOfType<State<MainScreen>>();
                    // Catatan: Jika cara di atas sulit karena struktur, user bisa manual klik navbar.
                    // Tapi ini hanya teks visual.
                  },
                  child: const Text("See Activity >", style: TextStyle(color: AppTheme.neonGreen, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            // Teks Kecil di Kanan "You Have X Planned Activity"
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "You Have ${activities.length} Planned Activity",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LIST HORIZONTAL ACTIVITY CARD
            SizedBox(
              height: 140, // Tinggi kartu agar muat konten vertikal
              child: recentActivities.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  return _buildActivityCard(activity);
                },
              ),
            ),

            const SizedBox(height: 80), // Space bawah agar tidak tertutup navbar
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // 1. Item Progress
  Widget _buildProgressItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.neonGreen),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // 2. KARTU ACTIVITY (DESAIN KOTAK VERTIKAL SEPERTI HOME(3).PNG)
  Widget _buildActivityCard(ActivityModel activity) {
    return Container(
      width: 130, // Lebar kotak
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Warna Abu Gelap
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Activity (Putih, Bold)
          Text(
            activity.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),

          const Spacer(), // Dorong konten ke bawah

          // Row Bawah: Tipe & Jam
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tipe Activity (Running/Walking...)
              Text(
                activity.type,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              // Jam (10:00 AM)
              Text(
                DateFormat('hh:mm a').format(activity.startDate),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 3. Tampilan Kosong
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: const Center(
        child: Text(
          "No planned activities yet.",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
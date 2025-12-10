import 'dart:async'; // WAJIB ADA: Untuk jam berjalan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../core/theme.dart';
import '../../services/weather_service.dart';
import '../add_activity/add_activity_screen.dart';
import 'add_activity/add_activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel Cuaca
  String temp = "0";
  String desc = "Loading...";
  String cityName = "Gowa";
  String feelsLike = "0";
  String iconCode = "01d";

  // Variabel Jam
  String _timeString = "00:00";
  String _dateString = "";
  late Timer _timer;

  final _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _startClock(); // Mulai jalankan jam
  }

  @override
  void dispose() {
    _timer.cancel(); // Matikan jam kalau keluar aplikasi biar hemat baterai
    super.dispose();
  }

  // Fungsi Jam Berjalan (Real-time)
  void _startClock() {
    _updateTime(); // Set awal
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = DateFormat('HH:mm').format(now); // Contoh: 09:03
      _dateString = DateFormat('EEEE, d MMM yyyy').format(now); // Contoh: Thursday, 31 Aug 2025
    });
  }

  // Fungsi Ambil Cuaca
  void _fetchWeather() async {
    try {
      final data = await _weatherService.getWeather("Gowa");
      setState(() {
        temp = data['main']['temp'].toStringAsFixed(0);
        feelsLike = data['main']['feels_like'].toStringAsFixed(0);
        desc = data['weather'][0]['main'];
        cityName = data['name'];
        iconCode = data['weather'][0]['icon'];
      });
    } catch (e) {
      print("Error cuaca: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil Nama Depan User
    String fullName = Provider.of<AuthProvider>(context).userName;
    String firstName = fullName.split(' ')[0];

    return Scaffold(
      backgroundColor: AppTheme.blackBg,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1. HEADER (Sapaan Nama)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, $firstName! 👋",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "It's time to challenge your limits",
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),

                  // Tombol Lonceng
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

              // 2. WEATHER CARD (DESAIN SESUAI GAMBAR)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.neonGreen),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Kiri: Lokasi, Cuaca, Tanggal, JAM BESAR
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cityName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)),
                        Text(desc, style: const TextStyle(fontSize: 16, color: AppTheme.neonGreen)),

                        const SizedBox(height: 15),

                        // Tanggal Kuning
                        Text(_dateString, style: const TextStyle(fontSize: 12, color: Color(0xFFC1FF00))),

                        // JAM BESAR (Real-time)
                        Text(
                            _timeString,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)
                        ),
                      ],
                    ),

                    // Kanan: Icon & Suhu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.network(
                          'https://openweathermap.org/img/wn/$iconCode@2x.png',
                          width: 60, height: 60,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, color: Colors.white, size: 50),
                        ),
                        Text("$temp°C", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("Feels: $feelsLike°C", style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.neonGreen),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProgressItem(Icons.access_time, "Total Duration", "200m"),
                    _buildProgressItem(Icons.local_fire_department, "Total Calories", "350kl"),
                    _buildProgressItem(Icons.directions_run, "Total Activities", "4 act"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 4. MY ACTIVITY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("See Activity >", style: const TextStyle(color: AppTheme.neonGreen)),
                ],
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Text("You Have 2 Planned Activity", style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(height: 15),

              Container(
                height: 140,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.neonGreen),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 130,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Lari Bareng\n$firstName", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          const Text("Running", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const Text("10:00 AM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),

                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 40, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.neonGreen,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddActivityScreen())),
        child: const Icon(Icons.add, color: Colors.black),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: AppTheme.neonGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildProgressItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.neonGreen),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
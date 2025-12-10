import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../services/weather_service.dart';
import '../providers/auth_provider.dart';
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
  String iconCode = "01d";
  // String feelsLike = "0"; // Kita matikan dulu karena Model backend belum support ini

  // Variabel Jam
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
    _timer.cancel();
    super.dispose();
  }

  void _startClock() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    if (!mounted) return; // Cek agar tidak error saat pindah layar
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = DateFormat('HH:mm').format(now);
      _dateString = DateFormat('EEEE, d MMM yyyy').format(now);
    });
  }

  // --- PERBAIKAN 1: PANGGIL CUACA PAKAI TITIK (.) BUKAN KURUNG SIKU [] ---
  void _fetchWeather() async {
    try {
      final data = await _weatherService.getWeather("Gowa"); // data ini tipe-nya WeatherModel
      if (!mounted) return;

      setState(() {
        // Karena ini Object, panggilnya pakai titik
        temp = data.temperature.toStringAsFixed(0);
        desc = data.description;
        cityName = data.cityName;
        iconCode = data.iconCode;
      });
    } catch (e) {
      print("Error cuaca: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN 2: AMBIL NAMA DARI FIREBASE USER ---
    // AuthProvider Asli tidak punya 'userName', tapi punya 'user' (dari Firebase)
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Ambil nama dari email (karena nama asli mungkin belum diset saat register)
    // Contoh: "budi@gmail.com" -> diambil "budi"
    String fullName = user?.email?.split('@')[0] ?? "Runner";

    // Huruf kapital di awal (opsional, biar rapi)
    if (fullName.isNotEmpty) {
      fullName = fullName[0].toUpperCase() + fullName.substring(1);
    }

    String firstName = fullName; // Sementara pakai satu kata dulu

    return Scaffold(
      backgroundColor: AppTheme.blackBg, // Pastikan warna ini ada di theme.dart, kalau error ganti Colors.black

      body: SafeArea(
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

              // 2. WEATHER CARD
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cityName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)),
                        Text(desc, style: const TextStyle(fontSize: 16, color: AppTheme.neonGreen)),
                        const SizedBox(height: 15),
                        Text(_dateString, style: const TextStyle(fontSize: 12, color: Color(0xFFC1FF00))),
                        Text(
                            _timeString,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.network(
                          'https://openweathermap.org/img/wn/$iconCode@2x.png',
                          width: 60, height: 60,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, color: Colors.white, size: 50),
                        ),
                        Text("$temp°C", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                        // Text("Feels: $feelsLike°C", style: const TextStyle(fontSize: 12, color: Colors.grey)), // Dimatikan sementara
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. MY PROGRESS (Statik dulu gapapa)
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
                    _buildProgressItem(Icons.access_time, "Total Duration", "0m"),
                    _buildProgressItem(Icons.local_fire_department, "Total Calories", "0kl"),
                    _buildProgressItem(Icons.directions_run, "Total Activities", "0 act"),
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
              const Align(
                alignment: Alignment.centerRight,
                child: Text("Planned Activity", style: TextStyle(color: Colors.white, fontSize: 12)),
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
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Add Activity", style: TextStyle(color: Colors.grey)),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: AppTheme.neonGreen, size: 40),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddActivityScreen()));
                              },
                            ),
                          ],
                        ),
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

      // Bottom Bar dihapus saja kalau sudah ada di MainWrapper/PageController
      // Tapi kalau mau dipakai di sini, biarkan saja
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
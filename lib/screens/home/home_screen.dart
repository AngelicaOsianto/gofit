import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../core/theme.dart';
import '../../services/weather_service.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';
import '../../providers/notification_provider.dart';
import '../notification/notification_screen.dart';
import '../../providers/page_provider.dart'; // <--- IMPORT INI

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String temp = "0";
  String desc = "Loading...";
  String cityName = "Palu";
  String iconCode = "01d";
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
    final DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8)); // WITA
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm').format(now);
        _dateString = DateFormat('EEEE, d MMM yyyy').format(now);
      });
    }
  }

  void _fetchWeather() async {
    try {
      final data = await _weatherService.getWeather("Palu");
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String firstName = authProvider.userName.split(' ')[0];
    final activityProvider = Provider.of<ActivityProvider>(context);
    final activities = activityProvider.activities;
    final recentActivities = activities.take(5).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
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
                Consumer<NotificationProvider>(
                  builder: (context, notifProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
                            child: const Icon(Icons.notifications, color: Colors.white),
                          ),
                          if (notifProvider.unreadCount > 0)
                            Positioned(
                              right: 0, top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                child: Text('${notifProvider.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // WEATHER CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.neonGreen)),
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
                      Text(_timeString, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.neonGreen)),
                    ],
                  ),
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

            // PROGRESS
            const Text("My Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.neonGreen), color: Colors.transparent),
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

            // MY ACTIVITY SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("My Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                // --- NAVIGASI DIPERBAIKI ---
                GestureDetector(
                  onTap: () {
                    // Pindah ke Tab Activity (Index 1)
                    Provider.of<PageProvider>(context, listen: false).setPage(1);
                  },
                  child: const Text("See Activity >", style: TextStyle(color: AppTheme.neonGreen, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(padding: const EdgeInsets.only(top: 4.0), child: Text("You Have ${activities.length} Planned Activity", style: const TextStyle(color: Colors.white70, fontSize: 12))),
            ),
            const SizedBox(height: 15),

            // LIST ACTIVITY
            SizedBox(
              height: 140,
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
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

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

  Widget _buildActivityCard(ActivityModel activity) {
    return Container(
      width: 130, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(activity.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(activity.type, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              Text(DateFormat('HH:mm').format(activity.startDate), style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withValues(alpha: 0.2))),
      child: const Center(child: Text("No planned activities yet.", style: TextStyle(color: Colors.grey))),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
// Import Semua Halaman
import 'home/home_screen.dart';
import 'activity/activity_list_screen.dart';
import 'activity/activity_form_screen.dart';
import 'timer/timer_screen.dart';
import 'history/history_screen.dart';
import 'profile/profile_screen.dart';
// Import Providers
import '../providers/activity_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/page_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _reminderChecker;

  // --- DAFTAR HALAMAN ---
  final List<Widget> _pages = [
    const HomeScreen(),         // Index 0
    const ActivityListScreen(), // Index 1
    const TimerScreen(),        // Index 2
    const HistoryScreen(),      // Index 3
    const ProfileScreen(),      // Index 4
  ];

  @override
  void initState() {
    super.initState();
    _startReminderChecker();
  }

  @override
  void dispose() {
    _reminderChecker?.cancel();
    super.dispose();
  }

  void _startReminderChecker() {
    // Cek setiap 1 detik
    _reminderChecker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
      final notifProvider = Provider.of<NotificationProvider>(context, listen: false);

      // PERBAIKAN PENTING: Gunakan Waktu WITA agar sinkron dengan Dashboard
      final now = DateTime.now().toUtc().add(const Duration(hours: 8));

      for (var activity in activityProvider.activities) {
        // Cek apakah aktivitas punya reminder & belum muncul notifnya
        if (activity.reminderTime != null && !activity.isReminderSent) {

          final difference = now.difference(activity.reminderTime!).inMinutes;

          // LOGIKA POP-UP:
          // 1. Waktu sekarang (WITA) sudah melewati/sama dengan waktu reminder
          // 2. Selisihnya tidak lebih dari 60 menit (agar notifikasi basi tidak muncul)
          if (now.isAfter(activity.reminderTime!) && difference < 60) {

            // 1. Tandai agar tidak muncul lagi
            activityProvider.markReminderAsSent(activity.id);

            // 2. Tambah notifikasi ke lonceng
            notifProvider.addNotification(
                "It's Time!",
                "Time for ${activity.title} (${activity.type})",
                now
            );

            // 3. MUNCULKAN POP-UP
            _showReminderDialog(activity.title, activity.type);
          }
        }
      }
    });
  }

  void _showReminderDialog(String title, String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.neonGreen, width: 2)
        ),
        title: Column(
          children: [
            const Icon(Icons.alarm_on, color: AppTheme.neonGreen, size: 50),
            const SizedBox(height: 10),
            Text("REMINDER!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("It's time for your activity:", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(type.toUpperCase(), style: const TextStyle(color: AppTheme.neonGreen, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Later", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.of(ctx).pop();
              // Pindah ke Tab Timer (Index 2)
              Provider.of<PageProvider>(context, listen: false).setPage(2);
            },
            child: const Text("Let's Go!"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.blackBg,

          body: _pages[pageProvider.currentIndex],

          floatingActionButton: pageProvider.currentIndex == 1
              ? FloatingActionButton(
            backgroundColor: AppTheme.neonGreen,
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityFormScreen(activityId: null),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.black, size: 30),
          )
              : null,

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: pageProvider.currentIndex,
            selectedItemColor: AppTheme.neonGreen,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              pageProvider.setPage(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Activity'),
              BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), label: 'Timer'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
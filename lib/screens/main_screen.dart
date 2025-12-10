import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'home/home_screen.dart';
import 'activity/activity_list_screen.dart';
import 'activity/activity_form_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar Halaman
  final List<Widget> _pages = [
    const HomeScreen(),         // Index 0: Dashboard
    const ActivityListScreen(), // Index 1: Activity List
    const Center(child: Text("Timer Feature Coming Soon", style: TextStyle(color: Colors.white))),
    const Center(child: Text("History Feature Coming Soon", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Profile Feature Coming Soon", style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBg,

      // BODY: Berubah sesuai halaman yang dipilih
      body: _pages[_selectedIndex],

      // FAB: Hanya muncul jika _selectedIndex == 1 (Halaman Activity)
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
        backgroundColor: AppTheme.neonGreen,
        shape: const CircleBorder(),
        onPressed: () {
          // Navigasi ke Form Tambah
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ActivityFormScreen(activityId: null),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      )
          : null, // Jika bukan halaman Activity, FAB hilang

      // BOTTOM NAVBAR: Selalu ada
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed, // Agar 5 icon muat
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.neonGreen,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), label: 'Timer'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/activity_model.dart';
import '../../providers/activity_provider.dart';
import '../../main.dart'; // Akses AuthProvider
import '../activity/add_activity_screen.dart';
import 'widgets/activity_card.dart';
import 'widgets/recent_activity_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tambahkan State untuk mengontrol proses loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat data dari Firebase saat initState
    _loadData();
  }

  // Fungsi untuk memuat data dari Firebase
  Future<void> _loadData() async {
    // Dapatkan instance ActivityProvider
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    // Dapatkan instance AuthProvider (agar bisa cek sesi)
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Pastikan user sudah login sebelum mengambil data
      if (authProvider.isAuthenticated) {
        // Panggil fungsi fetchActivities yang sudah kita buat di ActivityProvider
        await activityProvider.fetchActivities();
      }
    } catch (e) {
      // Menangani error fetching data
      print("Error loading activities: $e");
    }

    // Setelah selesai, matikan loading
    if(mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Akses Provider untuk mendapatkan data Activities dan User
    final activityProvider = Provider.of<ActivityProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Ambil aktivitas yang BELUM SELESAI untuk ditampilkan di Home
    final upcomingActivities = activityProvider.activities.where((a) => !a.isCompleted).toList();

    // Ambil data user
    final userName = authProvider.userName;

    return Scaffold(
      backgroundColor: AppTheme.blackBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.blackBg,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppTheme.neonGreen),
            onPressed: () async {
              // Logika Logout
              await authProvider.logout();
              if (mounted) {
                // Pindah ke halaman Register/Login setelah logout
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),

      // Floating Action Button untuk menambah aktivitas
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddActivityScreen())),
        backgroundColor: AppTheme.neonGreen,
        child: const Icon(Icons.add, color: Colors.black),
      ),

      // Konten utama: menampilkan loading atau data
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.neonGreen)) // Tampilkan Loading
          : RefreshIndicator( // Menambahkan fitur pull-to-refresh
        onRefresh: _loadData, // Panggil lagi _loadData saat di pull-down
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          physics: const AlwaysScrollableScrollPhysics(), // Wajib agar RefreshIndicator bisa bekerja
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Header dan Profile ---
              _headerProfile(userName),
              const SizedBox(height: 25),

              // --- 2. Kartu Aktivitas Mendatang (Upcoming Activity) ---
              _cardSection(upcomingActivities),
              const SizedBox(height: 40),

              // --- 3. Recent Activity List ---
              const Text(
                "Your Recent Activities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              // Widget untuk menampilkan daftar riwayat aktivitas
              RecentActivityList(history: activityProvider.history),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget Header Profile
  Widget _headerProfile(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome back,",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper Widget Card Section
  Widget _cardSection(List<ActivityModel> upcomingActivities) {
    if (upcomingActivities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkGreen,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "You have no upcoming activities. Tap '+' to add one!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    // Ambil aktivitas terdekat (paling atas setelah di sort)
    final nextActivity = upcomingActivities.first;

    return ActivityCard(
      activity: nextActivity,
      onToggle: (id) => Provider.of<ActivityProvider>(context, listen: false).toggleActivityStatus(id),
    );
  }
}
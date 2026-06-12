import 'package:flutter/material.dart';
import 'package:app_pengaduan/theme/app_theme.dart';
import 'package:app_pengaduan/views/profile_page.dart';
import 'package:app_pengaduan/views/services/konsultasi_main_page.dart';
import 'package:app_pengaduan/views/chat/chat_list_page.dart';
import 'package:app_pengaduan/views/chat_konsultasi_page.dart';
import 'package:app_pengaduan/views/detail_pengaduan_page.dart';
import 'package:app_pengaduan/views/kategori_pengaduan.dart';
import 'package:app_pengaduan/views/informasi_kesehatan.dart';
import 'package:app_pengaduan/views/keluarga_berencana.dart';
import 'package:app_pengaduan/views/notification_page.dart';
import 'package:app_pengaduan/services/pengaduan_service.dart';
import 'package:app_pengaduan/model/pengaduan_model.dart';
import 'package:provider/provider.dart';
import 'package:app_pengaduan/viewmodels/auth_provider.dart' as custom_auth;
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const KonsultasiMainPage(), // Services
    const ChatListPage(),       // Chat
    const ProfilePage(),        // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'Services'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<custom_auth.AuthProvider>();
    final userId = authProvider.currentUserData?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    final nik = authProvider.currentUserData?.nik;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Pagi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      "Siap mengurus administrasi hari ini?",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, size: 28),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search
            TextField(
              decoration: InputDecoration(
                hintText: "Cari layanan, berita, atau laporan...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Berita Hangat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Berita Hangat",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Lihat Semua", style: TextStyle(color: AppTheme.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildNewsCard(
                    'Pembangunan Taman Terbuka Hijau Tahap III Dimulai', 
                    '10 Okt 2024',
                    'https://loremflickr.com/400/200/health,clinic?lock=1',
                  ),
                  _buildNewsCard(
                    'Jadwal Pelayanan Posyandu Balita Bulan Oktober', 
                    '09 Okt 2024',
                    'https://loremflickr.com/400/200/health,hospital?lock=2',
                  ),
                  _buildNewsCard(
                    'Program Vaksinasi Massal di Puskesmas Terpadu', 
                    '12 Okt 2024',
                    'https://loremflickr.com/400/200/medical,doctor?lock=3',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
// testing
            // Kategori Layanan
            const Text(
              "Kategori Layanan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryItem(
                  context, 
                  "Konsultasi", 
                  Icons.support_agent, 
                  const Color(0xFFE6F4EA),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatKonsultasiPage())),
                ),
                _buildCategoryItem(
                  context, 
                  "Pengaduan", 
                  Icons.campaign_outlined, 
                  const Color(0xFFFFF0F0),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KategoriPengaduanPage())),
                ),
                _buildCategoryItem(
                  context, 
                  "Daftar KB", 
                  Icons.family_restroom, 
                  const Color(0xFFF0F9FF),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KbFormPage())),
                ),
                _buildCategoryItem(
                  context, 
                  "Informasi", 
                  Icons.info_outline, 
                  const Color(0xFFFFF7ED),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InformasiKesehatanPage())),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Aktivitas Terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aktivitas Terbaru",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, size: 20)),
              ],
            ),
            const SizedBox(height: 12),
            if (userId != null)
              StreamBuilder<List<PengaduanModel>>(
                stream: PengaduanService().getMyHistory(userId: userId, nik: nik),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Belum ada aktivitas terbaru.", style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                    );
                  }

                  final activities = snapshot.data!.take(5).toList(); // Show top 5
                  return Column(
                    children: activities.map((activity) {
                      bool isResolved = activity.status.toLowerCase() == 'selesai';
                      Color statusColor = isResolved ? AppTheme.primary : Colors.blue;
                      String statusText = isResolved ? 'Selesai' : 'Dalam Proses';
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildActivityCard(
                          activity.judul ?? 'Laporan Pengaduan', 
                          statusText, 
                          statusColor,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPengaduanPage(pengaduan: activity)));
                          }
                        ),
                      );
                    }).toList(),
                  );
                },
              )
            else
              const Center(child: Text("Silakan login untuk melihat aktivitas terbaru.")),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(String title, String date, String imageUrl) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon, Color bgColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String status, Color statusColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.assignment, color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Text('Baru saja', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

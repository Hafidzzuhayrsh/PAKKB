import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_pengaduan/theme/app_theme.dart';
import '../services/pengaduan_service.dart';
import '../model/pengaduan_model.dart';
import 'detail_pengaduan_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int _selectedTabIndex = 0; // 0: All, 1: In Progress, 2: Resolved

  Future<String?> _getUserNik() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data()?['nik'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.account_balance, color: AppTheme.primary, size: 24),
            const SizedBox(width: 8),
            const Text(
              'ServiceHub',
              style: TextStyle(color: AppTheme.primary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder<String?>(
        future: _getUserNik(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userNik = userSnapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Laporan',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pantau status laporan layanan publik Anda secara real-time.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildTabButton('All', 0),
                        const SizedBox(width: 8),
                        _buildTabButton('In Progress', 1),
                        const SizedBox(width: 8),
                        _buildTabButton('Resolved', 2),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              if (userNik == null)
                 const Expanded(
                   child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Silakan lengkapi profil Anda (NIK) untuk melihat riwayat.',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                   ),
                 )
              else
                 Expanded(
                   child: StreamBuilder<List<PengaduanModel>>(
                     stream: PengaduanService().getMyHistory(
                       userId: FirebaseAuth.instance.currentUser!.uid,
                       nik: userNik,
                     ),
                     builder: (context, snapshot) {
                       if (!snapshot.hasData) {
                         return const Center(child: CircularProgressIndicator());
                       }

                       var data = snapshot.data!;
                       
                       // Filter logic based on tabs
                       if (_selectedTabIndex == 1) {
                         data = data.where((element) => element.status.toLowerCase() != 'selesai').toList();
                       } else if (_selectedTabIndex == 2) {
                         data = data.where((element) => element.status.toLowerCase() == 'selesai').toList();
                       }

                       if (data.isEmpty) {
                         return const Center(child: Text("Belum ada riwayat di kategori ini", style: TextStyle(color: AppTheme.textSecondary)));
                       }

                       return ListView.builder(
                         padding: const EdgeInsets.symmetric(horizontal: 16),
                         itemCount: data.length,
                         itemBuilder: (context, i) {
                           return _buildPengaduanCard(data[i]);
                         },
                       );
                     },
                   ),
                 ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPengaduanCard(PengaduanModel data) {
    bool isResolved = data.status.toLowerCase() == 'selesai';
    Color statusColor = isResolved ? AppTheme.primary : Colors.orange;
    String statusText = isResolved ? 'RESOLVED' : 'IN PROGRESS';
    IconData leadingIcon = isResolved ? Icons.check_circle_outline : Icons.construction;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPengaduanPage(pengaduan: data)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(leadingIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(data.tanggal, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.judul ?? 'Laporan',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Kecamatan, Jakarta Pusat', // Mockup location if not in model
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
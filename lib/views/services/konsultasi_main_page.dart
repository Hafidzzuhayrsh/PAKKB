import 'package:flutter/material.dart';
import 'package:app_pengaduan/theme/app_theme.dart';
import '../chat_konsultasi_page.dart';

class KonsultasiMainPage extends StatelessWidget {
  const KonsultasiMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryLight.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di Konsultasi!',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Temukan bantuan profesional untuk setiap langkah perjalanan keluarga Anda hari ini.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pilih Konsultasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(onPressed: () {}, child: const Text('Lihat Semua', style: TextStyle(color: AppTheme.primary))),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildConsultationCard('Keluarga Berencana', 'Rencanakan masa depan...', Icons.family_restroom),
                  _buildConsultationCard('Psikologi', 'Konseling kesehatan mental', Icons.psychology),
                  _buildConsultationCard('Parenting', 'Bimbingan pola asuh anak', Icons.child_care),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Certified Experts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dr. Sarah Johnson', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('General Practitioner', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text('4.9 (120 reviews)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatKonsultasiPage()));
                        },
                        icon: const Icon(Icons.chat, color: AppTheme.primary),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12), maxLines: 2),
        ],
      ),
    );
  }
}

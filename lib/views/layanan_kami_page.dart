import 'package:flutter/material.dart';
import 'package:app_pengaduan/theme/app_theme.dart';
import 'chat_konsultasi_page.dart';
import 'keluarga_berencana.dart';
import 'kategori_pengaduan.dart';
import 'informasi_kesehatan.dart';
import 'services/konsultasi_main_page.dart';

class LayananKamiPage extends StatelessWidget {
  const LayananKamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Layanan Kami',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Pilih layanan yang Anda butuhkan',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _buildServiceCard(
            context,
            title: 'Konsultasi',
            description: 'Tanya jawab langsung dengan ahli profesional',
            icon: Icons.support_agent,
            color: const Color(0xFFE6F4EA),
            iconColor: AppTheme.primary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KonsultasiMainPage()),
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            context,
            title: 'Pengaduan',
            description: 'Sampaikan laporan atau keluhan Anda di sini',
            icon: Icons.campaign_outlined,
            color: const Color(0xFFFFF0F0),
            iconColor: Colors.redAccent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KategoriPengaduanPage()),
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            context,
            title: 'Daftar KB',
            description: 'Pendaftaran layanan Keluarga Berencana',
            icon: Icons.family_restroom,
            color: const Color(0xFFF0F9FF),
            iconColor: Colors.blueAccent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KbFormPage()),
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            context,
            title: 'Informasi',
            description: 'Berita dan informasi kesehatan terkini',
            icon: Icons.info_outline,
            color: const Color(0xFFFFF7ED),
            iconColor: Colors.orangeAccent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InformasiKesehatanPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

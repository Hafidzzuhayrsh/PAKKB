import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InformasiKesehatanPage extends StatelessWidget {
  const InformasiKesehatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Informasi Kesehatan',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner or Top Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryLight.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pentingnya Menjaga Kesehatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ketahui informasi terbaru seputar kesehatan fisik dan mental.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.health_and_safety,
                    size: 64,
                    color: AppTheme.primary.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Artikel Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildArticleCard(
              title: 'Cara Menjaga Kesehatan Jantung',
              date: '12 Okt 2024',
              imageUrl: 'https://loremflickr.com/400/200/heart,health?lock=5',
              summary: 'Ketahui langkah-langkah mudah yang dapat Anda lakukan setiap hari untuk menjaga kesehatan jantung agar tetap optimal.',
            ),
            const SizedBox(height: 16),
            _buildArticleCard(
              title: 'Manfaat Olahraga Rutin',
              date: '10 Okt 2024',
              imageUrl: 'https://loremflickr.com/400/200/exercise,health?lock=6',
              summary: 'Olahraga tidak hanya baik untuk fisik, tapi juga sangat bermanfaat untuk menjaga kesehatan mental dan mengurangi stres.',
            ),
            const SizedBox(height: 16),
            _buildArticleCard(
              title: 'Pentingnya Vaksinasi Balita',
              date: '08 Okt 2024',
              imageUrl: 'https://loremflickr.com/400/200/baby,health?lock=7',
              summary: 'Jadwal dan jenis vaksinasi yang wajib diberikan pada balita untuk meningkatkan kekebalan tubuh terhadap berbagai penyakit.',
            ),
            const SizedBox(height: 16),
            _buildArticleCard(
              title: 'Pola Makan Sehat Seimbang',
              date: '05 Okt 2024',
              imageUrl: 'https://loremflickr.com/400/200/food,health?lock=8',
              summary: 'Panduan menyusun menu makanan sehari-hari yang bergizi seimbang untuk seluruh anggota keluarga.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String date,
    required String imageUrl,
    required String summary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Baca Selengkapnya',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

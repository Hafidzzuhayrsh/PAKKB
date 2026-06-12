import 'package:flutter/material.dart';
import 'package:app_pengaduan/theme/app_theme.dart';
import '../model/pengaduan_model.dart';
import '../services/pengaduan_service.dart';
import 'package:app_pengaduan/views/edit_pengaduan_page.dart';

class DetailPengaduanPage extends StatefulWidget {
  final PengaduanModel? pengaduan;

  const DetailPengaduanPage({super.key, this.pengaduan});

  @override
  State<DetailPengaduanPage> createState() => _DetailPengaduanPageState();
}

class _DetailPengaduanPageState extends State<DetailPengaduanPage> {
  bool _isDeleting = false;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Laporan?', textAlign: TextAlign.center),
        content: const Text(
          'Laporan ini akan dihapus secara permanen dan tidak dapat dikembalikan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Tidak'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Ya, Hapus', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true && widget.pengaduan?.id != null) {
      setState(() => _isDeleting = true);
      try {
        await PengaduanService().deletePengaduan(widget.pengaduan!.id!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Laporan berhasil dibatalkan'),
              backgroundColor: Colors.red,
            ),
          );
          // Kembali ke halaman utama
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membatalkan laporan: $e')),
          );
        }
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pengaduan = widget.pengaduan;
    final String title = pengaduan?.judul ?? 'Lubang di Jalan Utama';
    final String desc = pengaduan?.deskripsi ?? 'Terdapat lubang jalan yang cukup dalam dan lebar.';
    final String status = pengaduan?.status ?? 'Sedang Diproses';
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.sync, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primary),
                          ),
                          const Text(
                            'Update terakhir: 2 jam yang lalu',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('ID Laporan', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                      Text(
                        '#${pengaduan?.id?.substring(0, 5) ?? '2324-089'}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF), // Light blue
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.construction, size: 12, color: Color(0xFF4F46E5)), // Indigo
                            SizedBox(width: 4),
                            Text('Infrastruktur', style: TextStyle(color: Color(0xFF4F46E5), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.priority_high, size: 12, color: Colors.red),
                            SizedBox(width: 4),
                            Text('Prioritas Tinggi', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Timeline Status
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Timeline Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineItem(
                    'Laporan Diterima',
                    '12 Okt 2024 • 08:30 AM',
                    'Laporan Anda telah diterima oleh sistem.',
                    true,
                    true,
                  ),
                  _buildTimelineItem(
                    'Validasi Laporan',
                    '12 Okt 2024 • 09:15 AM',
                    'Laporan diverifikasi oleh tim lapangan Dinas PU.',
                    true,
                    true,
                  ),
                  _buildTimelineItem(
                    'Sedang Diproses',
                    '13 Okt 2024 • 10:00 AM',
                    'Tim teknis sedang menuju lokasi untuk perbaikan sementara.',
                    true,
                    false,
                  ),
                  _buildTimelineItem(
                    'Selesai',
                    'Estimasi: 15 Okt 2024',
                    '',
                    false,
                    false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Action Buttons
            if (pengaduan != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPengaduanPage(pengaduan: pengaduan!),
                            ),
                          ).then((_) {
                            // You might want to refresh the detail page or pop it so user goes back to dashboard to see updated data.
                            Navigator.pop(context);
                          });
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isDeleting ? null : () => _confirmDelete(context),
                        icon: _isDeleting
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                              )
                            : const Icon(Icons.cancel_outlined, size: 18),
                        label: Text(_isDeleting ? 'Menghapus...' : 'Batalkan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, String desc, bool isCompleted, bool isPast, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.primary : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppTheme.primary : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: desc.isNotEmpty ? 60 : 40, // dynamic height based on content
                color: isPast ? AppTheme.primary : const Color(0xFFD1D5DB),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isCompleted ? AppTheme.textPrimary : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../model/pengaduan_model.dart';
import '../services/pengaduan_service.dart';
import '../style/colors.dart';
import '../style/text_style.dart';

class EditPengaduanPage extends StatefulWidget {
  final PengaduanModel pengaduan;

  const EditPengaduanPage({super.key, required this.pengaduan});

  @override
  State<EditPengaduanPage> createState() => _EditPengaduanPageState();
}

class _EditPengaduanPageState extends State<EditPengaduanPage> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.pengaduan.judul);
    _deskripsiController = TextEditingController(text: widget.pengaduan.deskripsi);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (_judulController.text.isEmpty || _deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi judul dan deskripsi pengaduan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await PengaduanService().updatePengaduan(
        widget.pengaduan.id ?? '',
        _judulController.text,
        _deskripsiController.text,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaduan berhasil diperbarui'), backgroundColor: AppColors.primary),
        );
        Navigator.pop(context); // Go back to detail page
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui pengaduan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengaduan', style: AppTextStyles.headline1),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Pengaduan',
              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _judulController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul pengaduan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Deskripsi Pengaduan',
              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(
                hintText: 'Jelaskan detail pengaduan anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

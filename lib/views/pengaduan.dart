import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import '../widget/bottom_navbar.dart';

class PengaduanModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String status;
  final String? nik;
  final String? userId;
  final Timestamp? createdAt;

  PengaduanModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.status,
    this.nik,
    this.userId,
    this.createdAt,
  });

  factory PengaduanModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return PengaduanModel(
      id: doc.id,
      judul: d['judul'] ?? '',
      deskripsi: d['deskripsi'] ?? '',
      status: d['status'] ?? '',
      nik: d['nik'],
      userId: d['userId'],
      createdAt: d['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
        'judul': judul,
        'deskripsi': deskripsi,
        'status': status,
        'nik': nik,
        'userId': userId,
        'createdAt': createdAt,
      };

  String get tanggal {
    if (createdAt == null) return '-';
    return createdAt!.toDate().toString();
  }
}

class PengaduanPage extends StatefulWidget {
  final String kategori;

  const PengaduanPage({
    super.key,
    required this.kategori,
  });

  @override
  State<PengaduanPage> createState() => _PengaduanPageState();
}

class _PengaduanPageState extends State<PengaduanPage> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController();
    _deskripsiController = TextEditingController();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Pengaduan',
          style: AppTextStyles.headline1,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori: ${widget.kategori}',
              style: AppTextStyles.bodyText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Judul Pengaduan',
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                onPressed: () {
                  // TODO: Implement submit functionality
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Kirim Pengaduan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
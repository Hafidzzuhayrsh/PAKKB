import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PengaduanViewModel extends ChangeNotifier {
  final TextEditingController keluhanController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final PengaduanService _service = PengaduanService();
  bool isLoading = false;
  String? errorMessage;

  Future<bool> submitPengaduan({required String kategori}) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User belum login');
      }

      final pengaduan = PengaduanModel(
        id: '',
        judul: kategori,
        deskripsi: keluhanController.text.trim(),
        status: 'menunggu',
        nik: nikController.text.trim(),
        userId: user.uid,
        createdAt: Timestamp.now(),
      );

      await _service.submitPengaduan(pengaduan);

      _clearForm();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _clearForm() {
    keluhanController.clear();
    nikController.clear();
  }

  @override
  void dispose() {
    keluhanController.dispose();
    nikController.dispose();
    super.dispose();
  }
}

class PengaduanModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String status;
  final String nik;
  final String? userId;
  final Timestamp createdAt;

  PengaduanModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.status,
    required this.nik,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'status': status,
      'nik': nik,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}

class PengaduanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitPengaduan(PengaduanModel pengaduan) async {
    await _firestore.collection('pengaduan').add(pengaduan.toMap());
  }
}
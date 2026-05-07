import 'package:cloud_firestore/cloud_firestore.dart';

class PengaduanModel {
  final String? id;
  final String kategori;
  final String nama;
  final String nik;
  final String noHp;
  final String alamat;
  final String keluhan;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  PengaduanModel({
    this.id,
    required this.kategori,
    required this.nama,
    required this.nik,
    required this.noHp,
    required this.alamat,
    required this.keluhan,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  // --- Adapters for Backward Compatibility (from Local changes) ---
  String get fullname => nama;
  String get phone => noHp;
  String get address => alamat;
  String get description => keluhan;
  
  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'menunggu':
        return 'Menunggu';
      case 'processed':
      case 'diproses':
        return 'Diproses';
      case 'done':
      case 'selesai':
        return 'Selesai';
      case 'rejected':
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }
  // ----------------------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'nama': nama,
      'nik': nik,
      'no_hp': noHp,
      'alamat': alamat,
      'keluhan': keluhan,
      'image_url': imageUrl,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory PengaduanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Handle timestamp which might vary or be null
    DateTime date;
    if (data['created_at'] != null) {
      date = (data['created_at'] as Timestamp).toDate();
    } else if (data['timestamp'] != null) {
      date = (data['timestamp'] as Timestamp).toDate(); 
    } else {
      date = DateTime.now();
    }

    return PengaduanModel(
      id: doc.id,
      kategori: data['kategori'] ?? '',
      nama: data['nama'] ?? data['fullname'] ?? 'Anonim',
      nik: data['nik'] ?? '',
      noHp: data['no_hp'] ?? data['phone'] ?? '',
      alamat: data['alamat'] ?? data['address'] ?? '',
      keluhan: data['keluhan'] ?? data['description'] ?? '',
      imageUrl: data['image_url'] ?? data['imageUrl'],
      status: data['status'] ?? 'menunggu',
      createdAt: date,
    );
  }

  Null get tanggal => null;

  Null get deskripsi => null;

  String? get judul => null;

  Null get userId => null;
}

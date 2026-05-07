class KbModel {
  String? id;
  String? userId; // Added userId
  String nama;
  String nik;
  String hp;
  String alamat;
  String layanan;
  DateTime tanggal;
  String status;

  KbModel({
    this.id,
    this.userId, // Added to constructor
    required this.nama,
    required this.nik,
    required this.hp,
    required this.alamat,
    required this.layanan,
    required this.tanggal,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
    'userId': userId, // Added to JSON
    'nama': nama,
    'nik': nik,
    'hp': hp,
    'alamat': alamat,
    'layanan': layanan,
    'tanggal': tanggal.toIso8601String(),
    'status': status,
    'created_at': DateTime.now().toIso8601String(),
  };

  factory KbModel.fromMap(Map<String, dynamic> map, String id) {
    return KbModel(
      id: id,
      userId: map['userId'], // Added from map
      nama: map['nama'] ?? '',
      nik: map['nik'] ?? '',
      hp: map['hp'] ?? '',
      alamat: map['alamat'] ?? '',
      layanan: map['layanan'] ?? '',
      tanggal: DateTime.parse(map['tanggal']),
      status: map['status'] ?? 'pending',
    );
  }
}

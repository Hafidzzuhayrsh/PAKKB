class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? nik;
  final String? phone;
  final String? fcmToken;
  final DateTime? createdAt;
  final String? address;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.role = 'user',
    this.nik,
    this.phone,
    this.fcmToken,
    this.createdAt,
    this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'user',
      nik: data['nik'],
      phone: data['phone'],
      fcmToken: data['fcmToken'],
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'nik': nik,
      'phone': phone,
      'fcmToken': fcmToken,
      'createdAt': createdAt?.toIso8601String(),
      'address': address,
    };
  }
}



  
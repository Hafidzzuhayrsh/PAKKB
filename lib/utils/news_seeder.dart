import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/pengaduan_model.dart';
import '../services/notification_service.dart';

class GlobalDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> seedAll() async {
    final user = _auth.currentUser;
    if (user == null) {
      print("❌ Cannot seed: No user logged in.");
      return;
    }

    final String uid = user.uid;
    String name = user.displayName ?? "";

    // Fetch user details from Firestore to be sure of the name
    String nik = "";

    // Fetch user details from Firestore to be sure of the name and NIK
    // We always fetch to check the NIK status accurately
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      if (name.isEmpty) {
        name = userDoc.data()?['name'] ?? userDoc.data()?['nama'] ?? "";
      }
      nik = userDoc.data()?['nik'] ?? "";
    }

    if (name.isEmpty) name = "Warga Padang Panjang";

    print("Checking Seeder for User: $name (uid: $uid, nik: '$nik')");

    // 1. Universal News Seed (Runs if empty)
    await _seedNews();

    // 2. User Specific Seed ('Gambrul' logic)
    // Condition: Name ends with 'gambrul' AND NIK is empty (User hasn't registered/seeded yet)
    if (name.toLowerCase().endsWith('gambrul') && nik.isEmpty) {
      print(
        "🌟 Seeding Special Data for '$name' (Detected 'gambrul' & No NIK)...",
      );
      await _seedYogaData(uid, name, user.email ?? "gambrul@example.com");
      print("🎉 DATA SEEDED FOR GAMBRUL!");
    } else {
      print(
        "ℹ️ Skipping auto-seed. Reason: ${!name.toLowerCase().endsWith('gambrul') ? "Name does not end in 'gambrul'" : "NIK already exists ('$nik')"}.",
      );
    }
  }

  // ==================== YOGA DATA ====================
  static Future<void> _seedYogaData(
    String uid,
    String name,
    String email,
  ) async {
    // 0. Check if already seeded to prevent duplicates
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data()?['is_seeded'] == true) {
      print("✅ User 'yoga' already seeded. Skipping duplicate data creation.");
      return;
    }

    const String nik = "1234567890123456";
    const String phone = "708510575484";
    const String address = "Jl. beccashi, No.69, RT6/RW9, Padang Panjang";

    // 1. Update Profile
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': 'yoga',
      'nik': nik,
      'phone': phone,
      'address': address,
      'role': 'user',
      'is_seeded': true,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 2. Pengaduan (3 items)
    final List<PengaduanModel> pengaduanList = [
      PengaduanModel(
        kategori: 'Administrasi',
        nama: name,
        nik: nik,
        noHp: phone,
        alamat: address,
        keluhan:
            "Saya kemarin daftar KB untuk 3 istri saya yang imut-imut, tetapi semuanya ditolak.",
        status: 'ditolak',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PengaduanModel(
        kategori: 'Keamanan',
        nama: name,
        nik: nik,
        noHp: phone,
        alamat: address,
        keluhan:
            "Lingkungan saya, Beccashi, tidak terasa aman, istri saya hampir dicuri.",
        status: 'selesai',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      PengaduanModel(
        kategori: 'Kesehatan',
        nama: name,
        nik: nik,
        noHp: phone,
        alamat: address,
        keluhan: "Lingkungan saya, Beccashi, butuh tes kesehatan gratis.",
        status: 'menunggu',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    for (var item in pengaduanList) {
      await _firestore.collection('pengaduan').add(item.toMap());
      // Trigger Notification for non-pending
      if (item.status != 'menunggu' && item.status != 'pending') {
        await NotificationService().sendNotification(
          userId: uid,
          title: "Pengaduan ${item.kategori}",
          body: "Pengaduan Anda statusnya kini: ${item.statusText}",
        );
      }
    }

    // 3. KB Registration
    final Map<String, dynamic> kbData = {
      'nama': name,
      'nik': nik,
      'hp': phone,
      'alamat': address,
      'layanan': 'Suntik KB 3 Bulan',
      'tanggal': "2025-12-25",
      'status': 'diproses',
      'created_at': DateTime.now().toIso8601String(),
    };

    await _firestore.collection('pendaftaran_kb').add(kbData);

    // Notification for KB
    String notifTitle = "Pendaftaran KB";
    String notifBody = "Pendaftaran KB anda sedang diproses.";

    await NotificationService().sendNotification(
      userId: uid,
      title: notifTitle,
      body: notifBody,
    );
  }

  static Future<void> _seedNews() async {
    // 1. Check if collection is completely empty (Fast path)
    final snapshot = await _firestore.collection('news').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      // Even if not empty, double check if ours exist (optional, or just return)
      // User reports duplication, so let's be safe: Check individually if we really want to prevent duplicates.
      // Actually, if it's not empty, we usually assume seeded. But let's check titles to be robust against partial state.
      // For efficiency, if any docs exist, we assume seeded to avoid reading all.
      print("News already seeded (Collection not empty).");
      return;
    }

    final List<Map<String, dynamic>> newsList = [
      {
        'title': 'Penyuluhan KB di Kecamatan Padang Panjang Barat',
        'content':
            'Dinas Kesehatan Kota Padang Panjang mengadakan penyuluhan mengenai pentingnya Keluarga Berencana bagi pasangan usia subur.',
        'image_url':
            'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=2070',
        'created_at': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'title': 'Pentingnya Gizi Seimbang untuk Ibu Hamil',
        'content':
            'Ahli gizi menekankan pentingnya asupan nutrisi yang seimbang selama masa kehamilan untuk mencegah stunting pada anak. Konsumsi sayur dan buah sangat disarankan.',
        'image_url':
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=2070',
        'created_at': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'title': 'Jadwal Imunisasi Balita Bulan Ini',
        'content':
            'Jangan lewatkan jadwal imunisasi rutin untuk balita Anda di Posyandu terdekat. Imunisasi lengkap melindungi anak dari berbagai penyakit berbahaya.',
        'image_url':
            'https://images.unsplash.com/photo-1632053001712-42b781b0a996?auto=format&fit=crop&q=80&w=2070',
        'created_at': DateTime.now().subtract(const Duration(days: 3)),
      },
    ];

    for (var item in newsList) {
      // Double check per item to prevent race condition duplicates if multiple clients seed same time
      final existing = await _firestore
          .collection('news')
          .where('title', isEqualTo: item['title'])
          .limit(1)
          .get();
      if (existing.docs.isEmpty) {
        await _firestore.collection('news').add(item);
      }
    }
    print("News Seeded.");
  }
}

class NewsSeeder {
  static Future<void> seedNews() async {
    await GlobalDataSeeder._seedNews();
  }
}

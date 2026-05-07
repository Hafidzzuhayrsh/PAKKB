import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/kb_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'pendaftaran_kb';

  Future<void> addPendaftaran(KbModel data) async {
    await _firestore.collection(collectionName).add(data.toJson());
  }

  Future<List<KbModel>> getPendaftaran({
    required String userId,
    String? nik,
  }) async {
    Query query = _firestore.collection(collectionName);

    if (nik != null && nik.isNotEmpty) {
      query = query.where('nik', isEqualTo: nik);
    } else {
      query = query.where('userId', isEqualTo: userId);
    }

    // Menghapus 'orderBy' server-side untuk menghindari error Index Firestore
    QuerySnapshot snapshot = await query.get();

    final List<KbModel> results = snapshot.docs.map((doc) {
      return KbModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    // Pengurutan data di sisi aplikasi (berdasarkan tanggal)
    results.sort((a, b) {
      return b.tanggal.compareTo(a.tanggal);
    });

    return results;
  }

  Future<void> updatePendaftaran(String id, KbModel data) async {
    await _firestore.collection(collectionName).doc(id).update(data.toJson());
  }

  Future<void> deletePendaftaran(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}

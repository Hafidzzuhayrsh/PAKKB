import 'package:app_pengaduan/model/pengaduan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PengaduanService {
  final _col = FirebaseFirestore.instance.collection('pengaduan');

  Stream<List<PengaduanModel>> getMyHistory({
    required String userId,
    String? nik,
  }) {
    return _col.orderBy('created_at', descending: true).snapshots().map((snap) {
      final all = snap.docs
          .map((d) => PengaduanModel.fromFirestore(d))
          .toList();

      return all.where((p) {
        if (nik != null && nik.isNotEmpty) {
          return p.nik == nik || p.userId == userId;
        }
        return p.userId == userId;
      }).toList();
    });
  }

  Future<void> submitPengaduan(PengaduanModel p) async {
    await _col.add(p.toMap());
  }

  Future<void> updatePengaduan(String id, String judul, String deskripsi) async {
    await _col.doc(id).update({
      'judul': judul,
      'deskripsi': deskripsi,
    });
  }

  Future<void> deletePengaduan(String id) async {
    await _col.doc(id).delete();
  }
}
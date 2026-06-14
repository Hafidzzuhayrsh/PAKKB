import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil data notifikasi berdasarkan User ID dan NIK
  Stream<List<NotificationModel>> getNotifications(
    String userId, {
    String? nik,
  }) {
    // Stream 1: Notifikasi berdasarkan ID Pengguna (untuk Chat)
    final streamUser = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );

    // Jika tidak ada NIK, kembalikan stream user saja
    if (nik == null || nik.isEmpty) {
      return streamUser;
    }

    // Stream 2: Notifikasi berdasarkan NIK (untuk Update KB)
    final streamNik = _firestore
        .collection('notifications')
        .where('recipientNik', isEqualTo: nik)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );

    // Menggabungkan kedua stream menjadi satu list
    return _combineStreams(streamUser, streamNik);
  }

  // Fungsi bantuan untuk menggabungkan dua stream menjadi satu list
  Stream<List<NotificationModel>> _combineStreams(
    Stream<List<NotificationModel>> s1,
    Stream<List<NotificationModel>> s2,
  ) {
    return Stream<List<NotificationModel>>.multi((controller) {
      List<NotificationModel> list1 = [];
      List<NotificationModel> list2 = [];

      // Fungsi untuk menggabungkan dan mengirim data ke UI
      void emit() {
        final combined = [...list1, ...list2];
        
        // Ensure unique by ID (in case a notification matches both userId and recipientNik)
        final uniqueMap = <String, NotificationModel>{};
        for (var item in combined) {
          uniqueMap[item.id] = item;
        }
        final uniqueList = uniqueMap.values.toList();
        
        // Sort descending by date
        uniqueList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        controller.add(uniqueList);
      }

      // Dengarkan perubahan pada stream 1
      s1.listen((data) {
        list1 = data;
        emit();
      });

      // Dengarkan perubahan pada stream 2
      s2.listen((data) {
        list2 = data;
        emit();
      });
    });
  }

  // Create a Notification (For Admin / Testing)
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'body': body,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }
}

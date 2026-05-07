import 'package:cloud_firestore/cloud_firestore.dart';

class KonsultasiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream messages for a specific consultation category and user (Private Chat)
  Stream<QuerySnapshot> messagesStream(String categoryId, String userId) {
    return _firestore
        .collection('konsultasi')
        .doc(categoryId)
        .collection('chats') // [NEW] Sub-collection for private chats
        .doc(userId) // [NEW] Document per user
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  /// Send a message and also write a notification doc for server-side FCM
  Future<void> sendMessage(
    String categoryId,
    String userId,
    String userName,
    String text,
  ) async {
    // 1. Write Message to Private Path
    final chatDocRef = _firestore
        .collection('konsultasi')
        .doc(categoryId)
        .collection('chats')
        .doc(userId);

    final messagesRef = chatDocRef.collection('messages');

    await messagesRef.add({
      'senderId': userId,
      'senderName': userName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Update Metadata for Admin Inbox List
    // This allows Admin to see "Who chatted recently?"
    await chatDocRef.set({
      'userId': userId,
      'userName': userName,
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
      'lastSenderId': userId,
      'isReadByAdmin': false, // Flag for Admin UI
      'unreadCountAdmin': FieldValue.increment(
        1,
      ), // [NEW] Increment admin unread count
    }, SetOptions(merge: true));

    // 3. Trigger Notification (Standard FCM Trigger)
    await _firestore.collection('notifications').add({
      'type': 'konsultasi_message',
      'categoryId': categoryId,
      'threadId':
          userId, // Important: Admin needs to know WHICH user thread to open
      'title': userName,
      'body': text,
      'fromUserId': userId,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Mark chat as read for User (resets unreadCountUser)
  Future<void> markAsRead(String categoryId, String userId) async {
    try {
      final chatDocRef = _firestore
          .collection('konsultasi')
          .doc(categoryId)
          .collection('chats')
          .doc(userId);

      await chatDocRef.update({
        'unreadCountUser': 0,
        'lastReadTimestampUser': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore if doc doesn't exist yet
    }
  }
}

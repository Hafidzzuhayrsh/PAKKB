import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatKonsultasiPage extends StatefulWidget {
  final String title;
  final String categoryId;

  const ChatKonsultasiPage({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  State<ChatKonsultasiPage> createState() => _ChatKonsultasiPageState();
}

class _ChatKonsultasiPageState extends State<ChatKonsultasiPage> {
  final TextEditingController _controller = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  CollectionReference get _chatRef => FirebaseFirestore.instance
      .collection('konsultasi')
      .doc(widget.categoryId)
      .collection('chats')
      .doc(user!.uid)
      .collection('messages');

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    await _chatRef.add({
      'message': _controller.text.trim(),
      'senderId': user!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // 🔥 LIST CHAT
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatRef.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data =
                        messages[index].data() as Map<String, dynamic>;

                    final isMe = data['senderId'] == user!.uid;

                    return _buildBubble(
                      message: data['message'] ?? '',
                      isMe: isMe,
                      timestamp: data['timestamp'],
                    );
                  },
                );
              },
            ),
          ),

          // 🔥 INPUT
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Tulis pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF16A34A),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🔥 BUBBLE CHAT
  Widget _buildBubble({
    required String message,
    required bool isMe,
    required dynamic timestamp,
  }) {
    String time = "";

    if (timestamp != null) {
      final date = timestamp.toDate();
      time = DateFormat('HH:mm').format(date);
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4, top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF16A34A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
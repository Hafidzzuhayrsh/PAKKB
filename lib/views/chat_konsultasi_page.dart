import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/konsultasi_service.dart';

class ChatKonsultasiPage extends StatefulWidget {
  final String title;
  final String categoryId;

  const ChatKonsultasiPage({
    super.key,
    this.title = 'Dr. Sarah Johnson',
    this.categoryId = 'default',
  });

  @override
  State<ChatKonsultasiPage> createState() => _ChatKonsultasiPageState();
}

class _ChatKonsultasiPageState extends State<ChatKonsultasiPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final KonsultasiService _service = KonsultasiService();
  String? _userId;
  String? _userName;
  DateTime? _lastReadTime;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;

    if (_userId != null) {
      FirebaseFirestore.instance.collection('users').doc(_userId).get().then((
        doc,
      ) {
        if (doc.exists) {
          final data = doc.data() ?? {};
          if (mounted) {
            setState(() {
              _userName = data['name'] ?? _userName;
            });
          }
        }
      });
      _initializeReadStatus();
    }
  }

  Future<void> _initializeReadStatus() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('konsultasi')
          .doc(widget.categoryId)
          .collection('chats')
          .doc(_userId)
          .get();

      if (doc.exists && mounted) {
        final data = doc.data();
        if (data != null) {
          final dynamic ts = data['lastReadTimestampUser'];
          if (ts is Timestamp) {
            setState(() {
              _lastReadTime = ts.toDate();
            });
          }
        }
      }

      if (mounted) {
        await _service.markAsRead(widget.categoryId, _userId!);
      }
    } catch (e) {
      debugPrint('Error initializing read status: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimestamp(dynamic ts) {
    if (ts == null) return '';
    DateTime dt;
    if (ts is Timestamp) {
      dt = ts.toDate();
    } else if (ts is int) {
      dt = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is DateTime) {
      dt = ts;
    } else {
      return '';
    }

    try {
      return DateFormat('hh:mm a').format(dt); // 10:30 AM format
    } catch (e) {
      return '';
    }
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _userId == null) return;

    await _service.sendMessage(
      widget.categoryId,
      _userId!,
      _userName ?? 'User',
      text.trim(),
    );
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> data) {
    final senderId = data['senderId'] as String? ?? '';
    final text = data['text'] as String? ?? '';
    final senderName = data['senderName'] as String? ?? '';
    final timestamp = data['timestamp'];
    final formattedTs = _formatTimestamp(timestamp);

    if (senderId == _userId) {
      return _buildUserMessage(context, text, formattedTs);
    } else {
      return _buildConsultantMessage(context, text, senderName, formattedTs);
    }
  }

  Widget _buildConsultantMessage(
    BuildContext context,
    String text,
    String senderName,
    String timestamp,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp.isNotEmpty ? timestamp : '10:30 AM',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48), // Padding on the right
        ],
      ),
    );
  }

  Widget _buildUserMessage(
    BuildContext context,
    String text,
    String timestamp,
    {bool hasImage = false}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 48), // Padding on the left
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasImage)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://i.pravatar.cc/300?u=thermometer', 
                          fit: BoxFit.cover, 
                          errorBuilder: (c,e,s) => const Center(child: Icon(Icons.thermostat, color: Colors.white, size: 40))
                        ),
                      ),
                    ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp.isNotEmpty ? timestamp : '10:32 AM',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all, color: Colors.white, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: AppTheme.textSecondary),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Light grey
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    suffixIcon: Icon(Icons.image_outlined, color: AppTheme.textSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {
                   if (_textController.text.isNotEmpty) {
                      _handleSubmitted(_textController.text);
                   }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Online \u2022 General Practitioner',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          // Date badge
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Text(
                'Today',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _userId == null
                  ? const Stream.empty()
                  : _service.messagesStream(widget.categoryId, _userId!),
              builder: (context, snapshot) {
                // Return dummy UI if no data or error (for presentation)
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                   return ListView(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     children: [
                       _buildConsultantMessage(context, "Hello! I'm Dr. Sarah. How are you feeling today? Please describe your symptoms so I can assist you better.", "Dr. Sarah Johnson", "10:15 AM"),
                       _buildUserMessage(context, "Hi Doctor, I've been having a persistent cough and a slight fever since yesterday morning.", "10:18 AM"),
                       _buildConsultantMessage(context, "I understand. Could you please send a photo of any prescriptions you're currently taking or a photo of your thermometer reading?", "Dr. Sarah Johnson", "10:20 AM"),
                       _buildUserMessage(context, "This is my temperature from 10 minutes ago.", "10:22 AM", hasImage: true),
                     ],
                   );
                }

                final docs = snapshot.data!.docs;

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: docs.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildMessageItem(data);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }
}

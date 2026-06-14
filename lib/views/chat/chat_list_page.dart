import 'package:flutter/material.dart';
import 'package:app_pengaduan/theme/app_theme.dart';
import '../chat_konsultasi_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pesan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChatItem(
                  context,
                  'Dr. Sarah Johnson',
                  'Silakan kirimkan foto resepnya.',
                  '10:30 AM',
                  true,
                ),
                _buildChatItem(
                  context,
                  'Dr. Budi Santoso',
                  'Terima kasih, sampai jumpa di sesi berikutnya.',
                  'Kemarin',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, String name, String message, String time, bool unread) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        radius: 24,
        backgroundColor: AppTheme.primary,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, style: TextStyle(fontWeight: unread ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: unread ? AppTheme.textPrimary : AppTheme.textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: TextStyle(color: unread ? AppTheme.primary : AppTheme.textSecondary, fontSize: 12)),
          if (unread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () {
        final doctorId = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatKonsultasiPage(title: name, categoryId: doctorId)));
      },
    );
  }
}

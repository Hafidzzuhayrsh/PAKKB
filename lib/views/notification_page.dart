import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_provider.dart' as custom_auth;
import '../model/notification_model.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current User ID and NIK
    final authProvider = context.watch<custom_auth.AuthProvider>();
    final userId = authProvider.currentUserData?.uid;
    final nik = authProvider.currentUserData?.nik;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pemberitahuan')),
        body: const Center(child: Text('Anda belum login')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemberitahuan'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationService().getNotifications(userId, nik: nik),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pemberitahuan'));
          }

          final notifications = snapshot.data!;
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.isRead
                      ? Colors.grey[300]
                      : Colors.green[100],
                  child: Icon(
                    Icons.notifications_active,
                    color: item.isRead ? Colors.grey : Colors.green,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await NotificationService().deleteNotification(item.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifikasi dihapus')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

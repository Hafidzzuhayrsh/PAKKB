import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewsModel {
  final String id;
  final String title;
  final String description; // or 'content'
  final String imagePath; // maps to 'image_url' (or 'imageUrl')
  final String date; // Formatted date string

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.date,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Format timestamp to String date
    Timestamp? ts = data['date'] ?? data['created_at']; 
    String formattedDate = '';
    if (ts != null) {
      formattedDate = DateFormat('dd MMM yyyy').format(ts.toDate());
    } else {
      formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    }

    return NewsModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['content'] ?? data['description'] ?? '', 
      imagePath: data['image_url'] ?? data['imageUrl'] ?? 'assets/images/foto_dummy_1.jpg',
      date: formattedDate,
    );
  }
}

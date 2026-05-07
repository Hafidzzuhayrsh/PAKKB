import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/news_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk mengambil Berita Populer (Trending)
  Stream<List<NewsModel>> getTrendingNews() {
    return _firestore
        .collection('news') // Nama koleksi di Firestore
        // .orderBy('date', descending: true) // Dihapus untuk menghindari error Index Firestore
        .snapshots()
        .map((snapshot) {
          final news = snapshot.docs
              .map((doc) => NewsModel.fromFirestore(doc))
              .toList();

          // Pengurutan data di sisi aplikasi (Client-side)
          // Saat ini mengembalikan urutan default dari Firestore
          return news;
        });
  }
}

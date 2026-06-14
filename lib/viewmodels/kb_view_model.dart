import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/kb_service.dart';
import '../model/kb_model.dart';

import '../services/notification_service.dart';

class KbViewModel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  List<KbModel> _listPendaftaran = [];
  bool _isLoading = false;

  List<KbModel> get listPendaftaran => _listPendaftaran;
  bool get isLoading => _isLoading;

  Future<void> fetchPendaftaran({String? nik}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _listPendaftaran = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _listPendaftaran = await _service.getPendaftaran(
        userId: user.uid,
        nik: nik,
      );
    } catch (e) {
      debugPrint("Error Fetch: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> simpanPendaftaran({
    required KbModel data,
    bool isEdit = false,
    String? id,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (isEdit) {
        await _service.updatePendaftaran(id!, data);
      } else {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          data.userId = user.uid;
        }
        await _service.addPendaftaran(data);
        
        // Send Notification for new registration
        if (user != null) {
          await NotificationService().sendNotification(
            userId: user.uid,
            title: "Pendaftaran KB Berhasil",
            body: "Pendaftaran KB ${data.layanan} untuk ${data.nama} telah berhasil dikirim.",
          );
        }
      }
      await fetchPendaftaran(nik: data.nik);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> hapusPendaftaran(String id) async {
    await _service.deletePendaftaran(id);
    await fetchPendaftaran(); // If we have nik stored in viewModel in future, pass it here. For now it triggers userId fetch if nik missing.
    // Ideally we preserve the last NIK used or fetch user data again.
    // For simplicity, let's assume subsequent fetches might need NIK again or just rely on manual refresh.
    // Or we can update the View to always pass NIK.
  }
}

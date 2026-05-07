import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_services.dart';
import '../model/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkCurrentUser();
  }

  UserModel? _currentUserData;
  UserModel? get currentUserData => _currentUserData;
  set currentUserData(UserModel? value) {
    _currentUserData = value;
  }

  // Check if email is verified
  bool get isEmailVerified => _user?.emailVerified ?? false;

  void _checkCurrentUser() async {
    _user = _authService.currentUser;
    if (_user != null) {
      await fetchUserData(); // Fetch user
    }
    notifyListeners();
  }

  Future<void> fetchUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  if (doc.exists) {
    currentUserData = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    notifyListeners();
  }
}

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signIn(email, password);

      if (_user != null) {
        await fetchUserData(); // Fetch data
      }

      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(
    String email,
    String password,
    String name,
    String nik,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signUp(email, password, name, nik);

      if (_user != null) {
        await fetchUserData();
      }

      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _currentUserData = null; // Clear user data
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String name,
    required String nik,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_user != null) {
        await _authService.updateUserProfile(_user!.uid, {
          'name': name,
          'nik': nik,
          'phone': phone,
          'address': address,
        });
        await fetchUserData(); // Refresh local data
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reload user
  Future<void> reloadUser() async {
    User? currentUser = _authService.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      _user = _authService.currentUser;
      notifyListeners();
    }
  }

  // Send verification email
  Future<void> sendVerificationEmail() async {
    if (_user != null && !_user!.emailVerified) {
      await _authService.sendVerificationEmail(_user!);
    }
  }
}

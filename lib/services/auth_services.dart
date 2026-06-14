import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Sign In with Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _saveUserToken(user.uid);
      }

      return user;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Save FCM Token to Firestore
  Future<void> _saveUserToken(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(userId).set({
          'fcmToken': token,
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print('FCM Token saved: $token');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  // Update User Profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Sign Up
  Future<User?> signUp(
    String email,
    String password,
    String name,
    String nik,
    String phone,
  ) async {
    try {
      // 1. Create User
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // 2. Save User Data (Role: User)
        String? token;
        try {
          token = await _firebaseMessaging.getToken();
        } catch (e) {
          print('Error getting FCM token during signup: $e');
        }
        
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'nik': nik, 
          'phone': phone, // Save phone
          'role': 'user', // Default role
          'createdAt': FieldValue.serverTimestamp(),
          'fcmToken': token,
        });

        // 3. Send Verification Email
        await user.sendEmailVerification();
      }

      return user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Current User
  User? get currentUser => _auth.currentUser;

  // Send Verification Email manually
  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }
}

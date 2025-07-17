import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      // Additional Firebase initialization can go here
    } catch (e) {
      throw Exception('Failed to initialize Firebase: $e');
    }
  }

  static bool get isInitialized => Firebase.apps.isNotEmpty;

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  static bool get isLoggedIn => currentUser != null;
}

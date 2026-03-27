import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Gerencia a inicialização e acesso central do Firebase (Cloud Firestore + Auth).
class FirebaseInstance {
  FirebaseInstance._();

  static bool _initialized = false;

  /// Inicializa FirebaseApp (chame antes de runApp).
  static Future<void> initialize() async {
    if (_initialized) return;
    await Firebase.initializeApp();
    _initialized = true;
  }

  /// Retorna a instância do Firestore.
  ///
  /// Chame `FirebaseInstance.initialize()` no startup antes de usar.
  static FirebaseFirestore get firestore {
    if (!_initialized) {
      throw StateError(
        'Firebase não inicializado. Chame FirebaseInstance.initialize() primeiro.',
      );
    }
    return FirebaseFirestore.instance;
  }

  /// Retorna a instância do Firebase Authentication.
  static FirebaseAuth get auth {
    if (!_initialized) {
      throw StateError(
        'Firebase não inicializado. Chame FirebaseInstance.initialize() primeiro.',
      );
    }
    return FirebaseAuth.instance;
  }
}

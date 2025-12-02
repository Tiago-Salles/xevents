import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {

  final FirebaseFirestore _db;
  final FirebaseApp app;

  /// Allow injecting FirebaseAuth/FirebaseFirestore for tests and flexibility.
  AuthService({required this.app, FirebaseAuth? auth, FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;
  
  late final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: app);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Sign in with email/password. Throws the original FirebaseAuthException when it occurs.
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Re-throw to allow callers to inspect code/message
      throw e;
    }
  }

  /// Register a new user, set display name and persist role in Firestore.
  Future<UserCredential> register(String name, String email, String password, String role) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user != null) {
        // Set the display name on the native user object
        await user.updateDisplayName(name);
        await user.reload();
      }

      final uid = credential.user!.uid;
      await _db.collection('users').doc(uid).set({'name': name, 'email': email, 'role': role});
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() => _auth.signOut();

  String? currentUserId() => _auth.currentUser?.uid;

  /// Stream of role: 'speaker' | 'customer' or null if not logged in
  Stream<String?> userRoleStream() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _db.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return doc.data()!['role'] as String?;
    });
  }

  Future<String?> getUserRoleOnce() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  }
}

/// Riverpod provider for AuthService.
/// The provider will construct an AuthService using the default Firebase app.
/// Ensure `Firebase.initializeApp()` runs before the provider is first read.
final authServiceProvider = Provider<AuthService>((ref) => AuthService(app: Firebase.app()));

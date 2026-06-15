import 'package:firebase_auth/firebase_auth.dart';

/// Singleton service wrapping [FirebaseAuth].
///
/// Provides login, signup, logout and auth-state stream.
/// Translates [FirebaseAuthException] codes into user-friendly messages.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Stream & current user ──────────────────────────────────────────────────

  /// Emits whenever the auth state changes (login / logout).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// The currently signed-in Firebase user, or `null`.
  User? get currentUser => _auth.currentUser;

  // ── Sign up ────────────────────────────────────────────────────────────────

  /// Creates a new account and returns the [UserCredential].
  /// Throws a [String] with a user-friendly message on failure.
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _friendlyMessage(e.code);
    }
  }

  // ── Log in ─────────────────────────────────────────────────────────────────

  /// Signs in with email + password and returns the [UserCredential].
  /// Throws a [String] with a user-friendly message on failure.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _friendlyMessage(e.code);
    }
  }

  // ── Log out ────────────────────────────────────────────────────────────────

  Future<void> logout() => _auth.signOut();

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Maps Firebase error codes to readable strings.
  String _friendlyMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

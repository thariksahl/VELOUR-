import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'user_model.dart';
import '../../core/services/firestore_service.dart';

/// Auth repository — dummy implementation.
/// Replace with Firebase Auth or REST API in production.
abstract class IAuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRepository implements IAuthRepository {
  final AuthService _authService = AuthService.instance;

  /// Converts a Firebase [User] into our app's [UserModel].
  UserModel _toUserModel(User user, {String? firstName, String? lastName}) {
    final displayName = user.displayName ?? '';
    final parts = displayName.split(' ');
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      firstName: firstName ?? (parts.isNotEmpty ? parts.first : ''),
      lastName: lastName ??
          (parts.length > 1 ? parts.sublist(1).join(' ') : ''),
      createdAt: user.metadata.creationTime,
    );
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.login(
      email: email,
      password: password,
    );
    final userModel = _toUserModel(credential.user!);
    // Upsert the Firestore profile document
    await FirestoreService.instance.upsertUserProfile(
      uid: credential.user!.uid,
      email: credential.user!.email ?? '',
    );
    return userModel;
  }

  @override
  Future<UserModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUp(
      email: email,
      password: password,
    );

    // Store the display name on the Firebase user profile
    await credential.user!.updateDisplayName('$firstName $lastName');

    final userModel = _toUserModel(
      credential.user!,
      firstName: firstName,
      lastName: lastName,
    );
    // Upsert the Firestore profile document with name
    await FirestoreService.instance.upsertUserProfile(
      uid: credential.user!.uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    return userModel;
  }

  @override
  Future<void> logout() => _authService.logout();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _authService.currentUser;
    if (user == null) return null;
    return _toUserModel(user);
  }
}

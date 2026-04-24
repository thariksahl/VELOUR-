import 'user_model.dart';

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
  // Simulated logged-in user state
  UserModel? _currentUser;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await _delay();

    // No password validation required for prototype


    _currentUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      firstName: 'Alex',
      lastName: 'Laurent',
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    await _delay(ms: 800);

    _currentUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await _delay(ms: 300);
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await _delay(ms: 200);
    return _currentUser;
  }

  Future<void> _delay({int ms = 600}) =>
      Future.delayed(Duration(milliseconds: ms));
}

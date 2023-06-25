import '../auth.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// you can call Auth.authRepo in the app any palace

class Auth {
  static final authRepo = AuthRepo();
  static init() async {
    await authRepo.user.first;
  }
}
/// {@endtemplate}
/// {@template confirmed_password}
/// Form input for a confirmed password input.
/// {@endtemplate}
class ConfirmedPassword {
  /// The original password.
  // final String password;

  static bool validator(String password, String? value) {
    return password == value ? true : false;
  }
}

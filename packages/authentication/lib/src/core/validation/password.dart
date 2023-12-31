/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Password {
  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  static bool validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '') ? true : false;
  }
}

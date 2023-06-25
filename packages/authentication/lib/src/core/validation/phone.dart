/// {@template password}
/// Form input for an Phone Number input.
/// {@endtemplate}
class PhoneNumber {
  static final _passwordRegExp = RegExp(r'^[0-9\d]{10,}$');

  static bool validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '') ? true : false;
  }
}

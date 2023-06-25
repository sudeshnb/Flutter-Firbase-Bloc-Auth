/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Email {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static bool validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '') ? true : false;
  }
}

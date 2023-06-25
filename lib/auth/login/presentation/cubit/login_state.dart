part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.isValid = false,
    this.phone = '',
    this.errorMessage,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final bool isValid;
  final String? errorMessage;
  final String phone;

  @override
  List<Object?> get props =>
      [email, password, status, isValid, errorMessage, phone];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    bool? isValid,
    String? errorMessage,
    String? phone,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      phone: phone ?? this.phone,
    );
  }
}

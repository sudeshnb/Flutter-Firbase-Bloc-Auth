part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = '',
    this.password = '',
    this.confirmedPassword = '',
    this.status = LoginStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final String confirmedPassword;
  final LoginStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        confirmedPassword,
        status,
        isValid,
        errorMessage,
      ];

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmedPassword,
    LoginStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

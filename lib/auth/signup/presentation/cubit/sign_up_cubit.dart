import 'package:auth/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_login/auth/model/enum.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthRepo _authenticationRepository;

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        isValid: Email.validator(value),
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(password: value, isValid: Password.validator(value)),
    );
  }

  void confirmedPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmedPassword: value,
        isValid: ConfirmedPassword.validator(state.password, value),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: LoginStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}

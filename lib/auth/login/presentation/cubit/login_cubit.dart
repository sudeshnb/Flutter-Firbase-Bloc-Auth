import 'package:auth/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:formz/formz.dart';

import '../../../model/enum.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(const LoginState());

  final AuthRepo _authRepo;

  void emailChanged(String value) {
    // final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: value,
        isValid: Email.validator(value),
      ),
    );
  }

  void passwordChanged(String value) {
    // final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: value,
        isValid: Password.validator(value),
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authRepo.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
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

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authRepo.logInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithGoogleFailure catch (e) {
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

  Future<void> logInWithApple() async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authRepo.logInWithWithApple();
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithGoogleFailure catch (e) {
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

  Future<void> logInWithPhoneNumber() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      var response = await _authRepo.logInWithPhoneNumber(phone: state.phone);
      response.fold((l) {
        // goto the otp verification page
        emit(state.copyWith(status: LoginStatus.otp));
      }, (r) => null);
    } on LogInWithPhoneNumberFailure catch (e) {
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

  Future<void> phoneNumberVerify({required String smsCode}) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      //  is string
      await _authRepo.verifyOtpCode(smsCode: smsCode);
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithPhoneNumberFailure catch (e) {
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

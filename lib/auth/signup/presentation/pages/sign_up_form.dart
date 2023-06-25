import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/model/enum.dart';
import 'package:flutter_firebase_login/auth/signup/presentation/sign_up.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key, required this.child, this.isFailure});
  final Widget child;
  final Function? isFailure;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure && isFailure == null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
        if (state.status.isFailure && isFailure != null) {
          isFailure!();
        }
      },
      child: child,
    );
  }
}

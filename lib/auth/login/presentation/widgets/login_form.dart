import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/model/enum.dart';

import 'package:flutter_firebase_login/auth/login/presentation/login.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.child, this.isFailure});
  final Widget child;
  final Function? isFailure;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isInProgress && isFailure == null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
        if (state.status.isInProgress && isFailure != null) {
          isFailure!();
        }
      },
      child: child,
    );
  }
}

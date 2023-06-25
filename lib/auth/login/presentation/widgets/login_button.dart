import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/model/enum.dart';
import 'package:flutter_firebase_login/auth/login/presentation/login.dart';
import 'package:flutter_firebase_login/widgets/widget.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    this.indicatorType = Loading.towRotaingArc,
    this.indicatorSize = 50,
    this.indicatorColor = Colors.blue,
    this.loadingIndicator = true,
    this.onPressed,
    required this.child,
  });

  final Loading indicatorType;
  final double indicatorSize;
  final Color indicatorColor;
  final Function? onPressed;
  final Widget child;
  final bool loadingIndicator;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (loadingIndicator && state.status.isInProgress) {
          return LoadingIndicator(
            animation: indicatorType,
            size: indicatorSize,
            color: indicatorColor,
          );
        } else {
          return ShrinkButton(
            key: const Key('loginForm_continue_raisedButton'),
            onPressed: () {
              if (state.isValid) {
                context.read<LoginCubit>().logInWithCredentials();
              }
              if (onPressed != null) onPressed!();
            },
            child: child,
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/login/presentation/login.dart';
import 'package:flutter_firebase_login/widgets/widget.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 150),
    this.delayed = const Duration(milliseconds: 200),
    this.shrinkScale = 0.9,
  });
  final Widget child;
  final double shrinkScale;
  final Duration duration;
  final Duration delayed;

  @override
  Widget build(BuildContext context) {
    return ShrinkButton(
      key: const Key('loginForm_googleLogin_raisedButton'),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      delayed: delayed,
      duration: duration,
      child: child,
    );
  }
}

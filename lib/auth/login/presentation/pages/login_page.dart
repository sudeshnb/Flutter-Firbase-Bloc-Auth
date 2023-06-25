import 'package:auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/login/presentation/cubit/login_cubit.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return OnyxsioLoginPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: const Padding(
          padding: EdgeInsets.all(8),
          child: LoginFormBody(),
        ),
      ),
    );
  }
}

///
class OnyxsioLoginPage extends StatelessWidget {
  const OnyxsioLoginPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthRepo>()),
      child: child,
    );
  }
}

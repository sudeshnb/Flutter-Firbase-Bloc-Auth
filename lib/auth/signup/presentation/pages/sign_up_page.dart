import 'package:auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/signup/presentation/sign_up.dart';
import 'package:flutter_firebase_login/auth/signup/presentation/widgets/widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return OnyxsioSignUpPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: const Padding(
          padding: EdgeInsets.all(8),
          child: SignUpForm(
            child: SignUpFormBody(),
          ),
        ),
      ),
    );
  }
}

///
class SignUpFormBody extends StatelessWidget {
  const SignUpFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment(0, -1 / 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///
          SignUPEmailInputField(),
          SizedBox(height: 8),

          ///
          SignupPasswordInputField(),
          SizedBox(height: 8),
          SignupRePasswordInputField(),
          SizedBox(height: 8),

          ///
          SignUpButton(child: Text('Signup')),
        ],
      ),
    );
  }
}

///
class OnyxsioSignUpPage extends StatelessWidget {
  const OnyxsioSignUpPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (_) => SignUpCubit(context.read<AuthRepo>()),
      child: child,
    );
  }
}

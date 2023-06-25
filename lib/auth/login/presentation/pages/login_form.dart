import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/auth/signup/presentation/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/widgets.dart';

class LoginFormBody extends StatelessWidget {
  const LoginFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoginForm(
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/bloc_logo_small.png',
                height: 120,
              ),
              const SizedBox(height: 16),
              const LoginEmailInputField(
                decoration: BoxDecoration(color: Colors.amber),
                inputDecoration: InputDecoration(
                  // isCollapsed: true,
                  // isDense: true,
                  labelText: 'email',
                  // helperText: '',
                  // errorText: '',
                ),
              ),
              const SizedBox(height: 8),
              // _PasswordInput(),
              const SizedBox(height: 8),

              ///
              const LoginPasswordInputField(errorText: 's'),

              ///
              const LoginButton(child: Text('LOGIN')),
              const SizedBox(height: 8),

              ///
              GoogleLoginButton(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                  ),
                  child: const Row(
                    children: [
                      Icon(FontAwesomeIcons.google),
                      Text(
                        'SIGN IN WITH GOOGLE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),

              ///
              CreateNewButton(
                onPressed: () =>
                    Navigator.of(context).push<void>(SignUpPage.route()),
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

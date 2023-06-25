import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/signup/presentation/sign_up.dart';
import 'package:flutter_firebase_login/widgets/input_background.dart';

class SignupPasswordInputField extends StatelessWidget {
  const SignupPasswordInputField({
    super.key,
    this.inputDecoration = const InputDecoration(),
    this.errorText = "",
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.decoration = const BoxDecoration(),
    this.height = 54.0,
    this.width = double.maxFinite,
    this.onChanged,
    this.controller,
    this.errorTextStyle,
    this.inputTextStyle,
  });

  final InputDecoration inputDecoration;
  final String errorText;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxDecoration decoration;
  final double width;
  final double height;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextStyle? errorTextStyle;
  final TextStyle? inputTextStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InputBackground(
              padding: padding,
              margin: margin,
              decoration: decoration,
              width: width,
              height: height,
              child: TextField(
                key: const Key('signUpForm_passwordInput_textField'),
                style: inputTextStyle,
                onChanged: (password) {
                  context.read<SignUpCubit>().passwordChanged(password);
                  if (onChanged != null) onChanged!(password);
                },
                obscureText: true,
                controller: controller,
                decoration: inputDecoration,
              ),
            ),
            // if (state.password.displayError != null && errorText.isEmpty)
            //   const Text('invalid password'),
            if (errorText.isNotEmpty)
              Padding(
                padding: padding.copyWith(top: 0, left: padding.left + 2),
                child: Text(
                  errorText,
                  style: errorTextStyle,
                ),
              )
          ],
        );
      },
    );
  }
}

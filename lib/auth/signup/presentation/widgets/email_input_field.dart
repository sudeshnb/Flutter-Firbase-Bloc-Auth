import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/auth/signup/presentation/sign_up.dart';
import 'package:flutter_firebase_login/widgets/input_background.dart';

class SignUPEmailInputField extends StatelessWidget {
  const SignUPEmailInputField({
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
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Column(
          key: const Key('signupForm_emailInput_textField'),
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
                style: inputTextStyle,
                keyboardType: TextInputType.emailAddress,
                scrollPadding: EdgeInsets.zero,
                onChanged: (email) {
                  context.read<SignUpCubit>().emailChanged(email);
                  if (onChanged != null) onChanged!(email);
                },
                controller: controller,
                decoration: inputDecoration,
              ),
            ),
            // if (state.email.displayError != null && errorText.isEmpty)
            //   const Text('invalid email'),
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

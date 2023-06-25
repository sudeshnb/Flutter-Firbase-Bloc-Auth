import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/widgets/widget.dart';

class CreateNewButton extends StatelessWidget {
  const CreateNewButton({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 150),
    this.delayed = const Duration(milliseconds: 200),
    this.shrinkScale = 0.9,
    this.onPressed,
  });
  final Widget child;
  final double shrinkScale;
  final Duration duration;
  final Duration delayed;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return ShrinkButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: onPressed,
      child: child,
    );
  }
}

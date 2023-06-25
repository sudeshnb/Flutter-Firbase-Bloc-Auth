import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/widgets/widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    required this.animation,
    required this.size,
    required this.color,
  });
  final Loading animation;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    switch (animation) {
      case Loading.prograssiveDots:
        return PrograssiveDots(
          size: size,
          color: color,
        );
      case Loading.towRotaingArc:
        return TwoRotatingArc(
          size: size,
          color: color,
        );
      case Loading.ios:
        return const CupertinoActivityIndicator();
      default:
        return const CircularProgressIndicator();
    }
  }
}

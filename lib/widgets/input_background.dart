import 'package:flutter/widgets.dart';

class InputBackground extends StatelessWidget {
  const InputBackground({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.decoration = const BoxDecoration(),
    this.height = 54.0,
    this.width = double.maxFinite,
  });
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxDecoration decoration;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: width,
        minHeight: height,
        minWidth: width,
      ),
      child: Center(child: child),
    );
  }
}

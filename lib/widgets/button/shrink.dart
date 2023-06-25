import 'package:flutter/material.dart';

class ShrinkButton extends StatefulWidget {
  final Function? onPressed;
  final double shrinkScale;
  final Widget child;
  final Duration duration;
  final Duration delayed;
  const ShrinkButton({
    super.key,
    this.onPressed,
    this.duration = const Duration(milliseconds: 150),
    this.delayed = const Duration(milliseconds: 200),
    required this.child,
    this.shrinkScale = 0.9,
  });

  @override
  State<ShrinkButton> createState() => _ShrinkButtonState();
}

class _ShrinkButtonState extends State<ShrinkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  ///
  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    scale = Tween<double>(
      begin: 1.0,
      end: widget.shrinkScale,
    ).animate(_controller);

    super.initState();
  }

  Future<void> _onTap() async {
    _controller.forward();
    await Future.delayed(widget.delayed, () => _controller.reverse());

    if (widget.onPressed != null) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(scale: scale, child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

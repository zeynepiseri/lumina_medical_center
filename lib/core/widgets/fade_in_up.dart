import 'package:flutter/material.dart';

class FadeInUp extends StatelessWidget {
  final Widget child;
  final int delay;
  final AnimationController controller;

  const FadeInUp({
    super.key,
    required this.child,
    required this.delay,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Animation<double> opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              (delay / 1000).clamp(0.0, 1.0),
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );

    final Animation<Offset> translate =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              (delay / 1000).clamp(0.0, 1.0),
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );

    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(position: translate, child: child),
    );
  }
}

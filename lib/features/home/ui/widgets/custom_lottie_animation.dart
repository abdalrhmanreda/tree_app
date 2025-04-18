import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAnimatedLottie extends StatefulWidget {
  final String lottiePath;
  final AnimationController controller;

  const CustomAnimatedLottie({
    super.key,
    required this.lottiePath,
    required this.controller,
  });

  @override
  State<CustomAnimatedLottie> createState() => _CustomAnimatedLottieState();
}

class _CustomAnimatedLottieState extends State<CustomAnimatedLottie> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.controller.value,
          child: Lottie.asset(
            widget.lottiePath,
            fit: BoxFit.contain,
            controller: widget.controller,
            repeat: false,
            onLoaded: (composition) {
              // ❌ لا تغير المدة إلى composition.duration
              if (!widget.controller.isAnimating) {
                widget.controller.forward(from: widget.controller.value);
              }
            },
          ),
        );
      },
    );
  }
}

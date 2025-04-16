import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constant/app_constant.dart';
import '../../../../generated/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation; // Animation to control size/growth
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    startAnimationCycle();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  void startAnimationCycle() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: AppConstant.deviceHeight(context) / 2.5,
            width: AppConstant.deviceWidth(context),
            child: Transform.scale(
              scale: _sizeAnimation.value, // Apply the gradual growth here
              child: Lottie.asset(
                Assets.imagesThree,
                fit: BoxFit.cover,
                controller: _controller,
                repeat: false,
                reverse: false,
                frameRate: FrameRate.composition,
                onLoaded: (composition) {
                  _controller.duration = const Duration(seconds: 30);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

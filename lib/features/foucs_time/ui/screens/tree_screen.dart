import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tree_app/core/constant/app_constant.dart';
import 'package:tree_app/core/helpers/spacing.dart';

import '../../../../generated/assets.dart';
import '../../../home/ui/widgets/custom_lottie_animation.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key, required this.min});

  final int min;

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> with TickerProviderStateMixin {
  late DateTime _endTime;
  bool _isPaused = false;
  Duration _remainingTime = Duration.zero;

  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(Duration(minutes: widget.min));

    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.min),
    )..forward();
  }

  void _pauseTimer() {
    setState(() {
      _remainingTime = _endTime.difference(DateTime.now());
      _isPaused = true;
      _lottieController.stop(); // وقف الشجرة
    });
  }

  List<Duration> _timeRecords = [];

  void _stopTimer() {
    setState(() {
      _isPaused = false;
      _lottieController.stop();
      // Reset the animation to beginning if you want
      _lottieController.reset();
    });

    // لو حابب ترجع المستخدم
  }

  void _resumeTimer() {
    setState(() {
      _endTime = DateTime.now().add(_remainingTime);
      _isPaused = false;
      _lottieController.forward(); // كمل الشجرة
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppConstant.deviceHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Tree'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_left_2_outline, color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight / 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomAnimatedLottie(
                controller: _lottieController,
                lottiePath: Assets.imagesThree,
              ),
            ),
          ),
          Spacing.verticalSpace(25),
          Text(
            'Focus for ${widget.min} minutes',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.verticalSpace(15),
          if (!_isPaused)
            TimerCountdown(
              format: CountDownTimerFormat.hoursMinutesSeconds,
              endTime: _endTime,
              onEnd: () {
                print("Timer finished");
              },
            )
          else
            Text(
              _formatDuration(_remainingTime),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          Spacing.verticalSpace(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Iconsax.stop_outline),
                iconSize: 30,
                color: Colors.black,
                tooltip: 'إيقاف',
                onPressed: _stopTimer, // حط الوظيفة المناسبة هنا
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  _isPaused ? Iconsax.play_outline : Iconsax.pause_outline,
                ),
                iconSize: 30,
                color: Colors.black,
                tooltip: _isPaused ? 'استئناف' : 'إيقاف مؤقت',
                onPressed: _isPaused ? _resumeTimer : _pauseTimer,
              ),
            ],
          ),

          // make records of time
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

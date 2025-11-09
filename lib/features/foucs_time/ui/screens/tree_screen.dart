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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(Duration(minutes: widget.min));

    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.min),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _pauseTimer() {
    setState(() {
      _remainingTime = _endTime.difference(DateTime.now());
      _isPaused = true;
      _lottieController.stop();
      _pulseController.stop();
    });
  }

  void _stopTimer() {
    setState(() {
      _isPaused = false;
      _lottieController.stop();
      _lottieController.reset();
      _pulseController.stop();
    });
    Navigator.pop(context);
  }

  void _resumeTimer() {
    setState(() {
      _endTime = DateTime.now().add(_remainingTime);
      _isPaused = false;
      _lottieController.forward();
      _pulseController.repeat(reverse: true);
    });
  }

  double _getProgress() {
    final totalDuration = Duration(minutes: widget.min);
    final elapsed = totalDuration - _remainingTime;
    return _isPaused
        ? elapsed.inSeconds / totalDuration.inSeconds
        : _lottieController.value;
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppConstant.deviceHeight(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Focus Tree',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _showExitDialog(context),
          icon: const Icon(Iconsax.arrow_left_2_outline),
          color: const Color(0xFF2D3748),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF5F7FA),
              const Color(0xFFE8F5E9).withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacing.verticalSpace(20),

              // Tree Animation with Circular Progress
              _buildTreeSection(screenHeight, screenWidth),

              // Timer Display
              _buildTimerSection(),

              // Control Buttons
              _buildControlButtons(),

              // Motivational Text
              _buildMotivationalText(),

              Spacing.verticalSpace(40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreeSection(double screenHeight, double screenWidth) {
    return ScaleTransition(
      scale: _isPaused ? const AlwaysStoppedAnimation(1.0) : _pulseAnimation,
      child: Container(
        width: screenWidth * 0.75,
        height: screenWidth * 0.75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular Progress Indicator
            SizedBox(
              width: screenWidth * 0.75,
              height: screenWidth * 0.75,
              child: AnimatedBuilder(
                animation: _lottieController,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _getProgress(),
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _isPaused ? Colors.orange : const Color(0xFF4CAF50),
                    ),
                  );
                },
              ),
            ),

            // Tree Lottie Animation
            SizedBox(
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              child: CustomAnimatedLottie(
                controller: _lottieController,
                lottiePath: Assets.imagesThree,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Focus Time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
          Spacing.verticalSpace(12),
          if (!_isPaused)
            TimerCountdown(
              format: CountDownTimerFormat.hoursMinutesSeconds,
              endTime: _endTime,
              timeTextStyle: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              colonsTextStyle: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
              onEnd: () {
                _showCompletionDialog();
              },
            )
          else
            Text(
              _formatDuration(_remainingTime),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          Spacing.verticalSpace(8),
          Text(
            '${widget.min} minutes session',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Iconsax.stop_outline,
            label: 'Stop',
            color: const Color(0xFFEF5350),
            onPressed: _stopTimer,
          ),
          _buildControlButton(
            icon: _isPaused ? Iconsax.play_outline : Iconsax.pause_outline,
            label: _isPaused ? 'Resume' : 'Pause',
            color: _isPaused ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
            onPressed: _isPaused ? _resumeTimer : _pauseTimer,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF81C784).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.lamp_charge_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _isPaused
                  ? 'Take a breath, resume when ready'
                  : 'Stay focused! Your tree is growing',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Leave Focus Session?'),
        content: const Text('Your progress will be lost if you leave now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Leave',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Congratulations!'),
        content: const Text('You completed your focus session!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
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
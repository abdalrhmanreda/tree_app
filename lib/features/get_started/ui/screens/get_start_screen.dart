import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tree_app/features/get_started/ui/screens/user_info.dart';
import 'package:tree_app/generated/assets.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../core/animation/fade_transaction.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/methods/get_responsive_text/responsive_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/get_started_content.dart';

class GetStartScreen extends StatefulWidget {
  const GetStartScreen({super.key});

  @override
  State<GetStartScreen> createState() => _GetStartScreenState();
}

class _GetStartScreenState extends State<GetStartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _imageAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    _contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF5F9F5),
              const Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: ScaleTransition(
                    scale: _imageAnimation,
                    child: ImageContainerWidget(),
                  ),
                ),
                Spacing.verticalSpace(30),
                Expanded(
                  flex: 4,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _contentAnimation,
                      child: const GetStartedContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Image Container Widget with decorative elements
class ImageContainerWidget extends StatelessWidget {
  const ImageContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Circle Decoration
        Positioned.fill(
          child: CustomPaint(
            painter: CircleDecorationPainter(),
          ),
        ),
        // Main Image Container
        Container(
          padding: EdgeInsets.all(20.w),
          child: Hero(
            tag: 'tree_logo',
            child: Image.asset(
              Assets.imagesGet,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Floating particles effect
        ...List.generate(
          6,
              (index) => FloatingParticle(index: index),
        ),
      ],
    );
  }
}

// Custom Painter for Background Circles
class CircleDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Outer circle
    paint.color = const Color(0xFF4CAF50).withOpacity(0.1);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.45,
      paint,
    );

    // Middle circle
    paint.color = const Color(0xFF4CAF50).withOpacity(0.15);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.35,
      paint,
    );

    // Inner circle
    paint.color = const Color(0xFF4CAF50).withOpacity(0.2);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.25,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Floating Particle Animation
class FloatingParticle extends StatefulWidget {
  final int index;

  const FloatingParticle({Key? key, required this.index}) : super(key: key);

  @override
  State<FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.index * 300)),
      vsync: this,
    )..repeat(reverse: true);

    final positions = [
      const Offset(-0.3, -0.4),
      const Offset(0.3, -0.3),
      const Offset(-0.4, 0.1),
      const Offset(0.4, 0.2),
      const Offset(-0.2, 0.4),
      const Offset(0.2, 0.3),
    ];

    _animation = Tween<Offset>(
      begin: positions[widget.index],
      end: Offset(
        positions[widget.index].dx * 1.2,
        positions[widget.index].dy * 1.2,
      ),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        width: 8 + (widget.index * 2).toDouble(),
        height: 8 + (widget.index * 2).toDouble(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// Improved Get Started Content Widget
class GetStartedContent extends StatelessWidget {
  const GetStartedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Name with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF66BB6A),
              ],
            ).createShader(bounds),
            child: Text(
              AppLocalizations.of(context)!.appName,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: getResponsiveFontSize(context, fontSize: 32),
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Spacing.verticalSpace(8),
          // Subtitle with decorative line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'Focus & Grow',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: getResponsiveFontSize(context, fontSize: 14),
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Container(
                width: 40.w,
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          Spacing.verticalSpace(24),
          // Description with better styling
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              AppLocalizations.of(context)!.getStartedDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: getResponsiveFontSize(context, fontSize: 15),
                color: AppColors.kGreyColor,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spacing.verticalSpace(32),
          // Enhanced Button with Animation
          EnhancedGetStartedButton(
            onPressed: () {
              Navigator.push(
                context,
                SecondFadeTransaction(const UserInfo()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Enhanced Get Started Button
class EnhancedGetStartedButton extends StatefulWidget {
  final VoidCallback onPressed;

  const EnhancedGetStartedButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<EnhancedGetStartedButton> createState() =>
      _EnhancedGetStartedButtonState();
}

class _EnhancedGetStartedButtonState extends State<EnhancedGetStartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Shimmer effect
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-1.0 + _pulseController.value * 2, 0),
                              end: Alignment(1.0 + _pulseController.value * 2, 0),
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Button content
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.getStarted,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: getResponsiveFontSize(
                            context,
                            fontSize: 18,
                          ),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Feature Badge Widget (Optional - can be added above button)
class FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureBadge({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: const Color(0xFF4CAF50),
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D5016),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/config/themes/font_weight.dart';
import 'package:tree_app/core/constant/app_constant.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';
import 'package:tree_app/features/home/ui/screens/home_screen.dart';

import '../../../../core/animation/fade_transaction.dart';
import '../../../../core/cache/shared_pref.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _lottieController;
  late AnimationController _formController;
  late AnimationController _buttonController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Lottie animation controller
    _lottieController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Form animation controller
    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Button pulse controller
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Start animations
    _lottieController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    _focusNode.dispose();
    _lottieController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate saving process
      await Future.delayed(const Duration(milliseconds: 800));

      await SharedPrefService().setString("userName", nameController.text);
      await SharedPrefService().setBool('isStart', true);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          SecondFadeTransaction(const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.verticalSpace(20),
                  // Welcome Header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: WelcomeHeaderWidget(),
                  ),
                  Spacing.verticalSpace(30),
                  // Lottie Animation
                  ScaleTransition(
                    scale: _lottieController,
                    child: LottieAnimationWidget(
                      controller: _lottieController,
                    ),
                  ),
                  Spacing.verticalSpace(40),
                  // Form Content
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: FormContentWidget(
                        nameController: nameController,
                        focusNode: _focusNode,
                      ),
                    ),
                  ),
                  Spacing.verticalSpace(40),
                  // Submit Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: EnhancedSubmitButton(
                      isLoading: _isLoading,
                      scaleAnimation: _scaleAnimation,
                      onPressed: _handleSubmit,
                    ),
                  ),
                  Spacing.verticalSpace(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Welcome Header Widget
class WelcomeHeaderWidget extends StatelessWidget {
  const WelcomeHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.waving_hand_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            Spacing.horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D5016),
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'Let\'s get to know you',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF81C784),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Lottie Animation Widget
class LottieAnimationWidget extends StatelessWidget {
  final AnimationController controller;

  const LottieAnimationWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstant.deviceHeight(context) / 3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),


      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Lottie.asset(
          Assets.imagesHello,
          controller: controller,
          fit: BoxFit.contain,
          repeat: true ,
          onLoaded: (composition) {
            controller.duration = composition.duration;
            controller.repeat(reverse: true); // This ensures it repeats forever with reverse
          },
          reverse: true ,

        ),
      ),
    );
  }
}

// Form Content Widget
class FormContentWidget extends StatelessWidget {
  final TextEditingController nameController;
  final FocusNode focusNode;

  const FormContentWidget({
    Key? key,
    required this.nameController,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          AppLocalizations.of(context)!.enterNameDescription,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D5016),
            height: 1.4,
          ),
        ),
        Spacing.verticalSpace(20),
        // Enhanced Text Field
        EnhancedTextField(
          controller: nameController,
          focusNode: focusNode,
        ),
        Spacing.verticalSpace(12),
        // Helper Text
        Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16.sp,
              color: const Color(0xFF81C784),
            ),
            Spacing.horizontalSpace(8),
            Expanded(
              child: Text(
                'This name will be used to personalize your experience',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.kGreyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Enhanced Text Field
class EnhancedTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const EnhancedTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? const Color(0xFF4CAF50)
              : const Color(0xFFE0E0E0),
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: _isFocused
            ? [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D5016),
        ),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.enterName,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.kGrayColor,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: const Color(0xFF4CAF50),
              size: 20.sp,
            ),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              widget.controller.clear();
              setState(() {});
            },
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.kGreyColor,
              size: 20.sp,
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 16.w,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.nameRequired;
          }
          if (value.length < 2) {
            return 'Name must be at least 2 characters';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}

// Enhanced Submit Button
class EnhancedSubmitButton extends StatelessWidget {
  final bool isLoading;
  final Animation<double> scaleAnimation;
  final VoidCallback onPressed;

  const EnhancedSubmitButton({
    Key? key,
    required this.isLoading,
    required this.scaleAnimation,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
              // Shimmer Effect
              if (!isLoading)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedBuilder(
                      animation: scaleAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(
                                -1.0 + scaleAnimation.value * 2,
                                0,
                              ),
                              end: Alignment(
                                1.0 + scaleAnimation.value * 2,
                                0,
                              ),
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
              // Button Content
              Center(
                child: isLoading
                    ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.start,
                      style: TextStyle(
                        fontSize: 18.sp,
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
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tree_app/core/cache/shared_pref.dart';
import 'package:tree_app/features/task/ui/screens/home_tasks_screen.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../foucs_time/ui/screens/foucs_time_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late String userName;
  DateTime selectedDate = DateTime.now();
  int currentIndex = 0;

  late AnimationController _navController;
  late AnimationController _fadeController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    userName = SharedPrefService().getString('userName') ?? 'User';

    _navController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 1.0,
    );

    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _navController.dispose();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    if (index == currentIndex) return;

    setState(() => currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );

    // Animate tab change
    _fadeController.forward(from: 0.0);
    _navController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      extendBody: true,
      body: Stack(
        children: [
          // Page View for smooth transitions
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
              _navController.forward(from: 0.0);
            },
            physics: const BouncingScrollPhysics(),
            children: const [
              HomeTasksScreen(),
              FocusTimeScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: EnhancedBottomNavigationBar(
        currentIndex: currentIndex,
        onTabChange: _onTabChange,
        animationController: _navController,
      ),
    );
  }
}

// Enhanced Bottom Navigation Bar
class EnhancedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;
  final AnimationController animationController;

  const EnhancedBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabChange,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                icon: Iconsax.task_square_outline,
                activeIcon: Iconsax.task_square_bold,
                label: 'Tasks',
                isActive: currentIndex == 0,
                onTap: () => onTabChange(0),
                animationController: animationController,
              ),
              NavBarItem(
                icon: Iconsax.timer_1_outline,
                activeIcon: Iconsax.timer_1_bold,
                label: 'Focus',
                isActive: currentIndex == 1,
                onTap: () => onTabChange(1),
                animationController: animationController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nav Bar Item
class NavBarItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final AnimationController animationController;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.animationController,
  }) : super(key: key);

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _scaleController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _scaleController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isActive ? 20.w : 16.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            gradient: widget.isActive
                ? const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.isActive
                ? [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  widget.isActive ? widget.activeIcon : widget.icon,
                  key: ValueKey(widget.isActive),
                  size: 24.sp,
                  color: widget.isActive
                      ? Colors.white
                      : const Color(0xFF81C784),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: widget.isActive
                    ? Row(
                  children: [
                    SizedBox(width: 8.w),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Optional: Floating Action Button for quick actions
class FloatingQuickActionButton extends StatefulWidget {
  const FloatingQuickActionButton({Key? key}) : super(key: key);

  @override
  State<FloatingQuickActionButton> createState() =>
      _FloatingQuickActionButtonState();
}

class _FloatingQuickActionButtonState extends State<FloatingQuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleMenu,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isExpanded ? 1.0 : 0.0,
              child: Container(
                color: Colors.black26,
              ),
            ),
          ),
        // Menu Items
        if (_isExpanded) ...[
          Positioned(
            bottom: 160.h,
            child: QuickActionItem(
              icon: Iconsax.add_bold,
              label: 'Add Task',
              color: const Color(0xFF4CAF50),
              onTap: () {
                _toggleMenu();
                // Handle add task
              },
            ),
          ),
          Positioned(
            bottom: 230.h,
            child: QuickActionItem(
              icon: Iconsax.timer_bold,
              label: 'Start Timer',
              color: const Color(0xFF66BB6A),
              onTap: () {
                _toggleMenu();
                // Handle start timer
              },
            ),
          ),
        ],
        // Main FAB
        Positioned(
          bottom: 90.h,
          child: GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: RotationTransition(
                turns: Tween<double>(begin: 0.0, end: 0.125).animate(
                  CurvedAnimation(
                    parent: _rotationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Icon(
                  _isExpanded ? Icons.close_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Quick Action Item
class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D5016),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
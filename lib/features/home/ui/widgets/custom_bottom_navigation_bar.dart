import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/core/helpers/spacing.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTabChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.kPrimaryColor,
              ),
              child: GNav(
                selectedIndex: currentIndex,
                onTabChange: onTabChange,
                rippleColor: AppColors.konBoardingAppBarColor,
                hoverColor: AppColors.kAppBarColor,
                haptic: true,
                tabBorderRadius: 32,
                style: GnavStyle.google,
                tabActiveBorder: Border.all(color: AppColors.kPrimaryColor),
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: 900),
                gap: 8,
                activeColor: AppColors.kPrimaryColor,
                color: Colors.white,
                iconSize: 24,
                tabBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                tabs: const [
                  GButton(
                    icon: Iconsax.home_outline,
                    text: 'Home',
                    backgroundColor: AppColors.kWhiteColor,
                  ),
                  GButton(
                    icon: Iconsax.heart_outline,
                    text: 'Likes',
                    backgroundColor: AppColors.kWhiteColor,
                  ),
                  GButton(
                    icon: Iconsax.clock_outline,
                    text: 'Timer',
                    backgroundColor: AppColors.kWhiteColor,
                  ),
                ],
              ),
            ),
          ),
          Spacing.horizontalSpace(5),
          const Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.kPrimaryColor,
              child: Icon(
                Iconsax.add_outline,
                color: AppColors.kWhiteColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

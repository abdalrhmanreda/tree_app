import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/features/task/ui/screens/create_task_screen.dart';

import '../../../../core/animation/fade_transaction.dart';

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
            flex: currentIndex == 0 ? 3 : 9,
            child: Container(
              margin: EdgeInsets.only(right: 70),
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
                    icon: Iconsax.clock_outline,
                    text: 'Timer',
                    backgroundColor: AppColors.kWhiteColor,
                  ),
                ],
              ),
            ),
          ),
          Spacing.horizontalSpace(5),
          if(currentIndex == 0)
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                // Handle the tap event here
                // showModalBottomSheet(
                //   isScrollControlled: true,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(20),
                //       topRight: Radius.circular(20),
                //     ),
                //   ),
                //   context: context,
                //   builder:
                //       (context) => Container(
                //         height: AppConstant.deviceHeight(context) / 1.5,
                //       ),
                // );
                Navigator.push(
                  context,
                  SecondFadeTransaction(const CreateTaskScreen()),
                );
              },
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
          ),
        ],
      ),
    );
  }
}

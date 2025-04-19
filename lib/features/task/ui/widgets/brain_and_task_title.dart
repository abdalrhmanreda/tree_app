import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/config/themes/font_weight.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';

import '../../../../generated/assets.dart';

class BrainAndTaskTitle extends StatelessWidget {
  const BrainAndTaskTitle({super.key, required this.taskTitle});

  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset(
            width: 30,
            height: 30,
            Assets.imagesBrain,
            fit: BoxFit.cover,
          ),
        ),
        Spacing.horizontalSpace(10),
        Expanded(
          child: Text(
            taskTitle,
            maxLines: 3,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 20),
              fontWeight: FontWeightHelper.bold,
              color: AppColors.kWhiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tree_app/config/themes/font_weight.dart';
import 'package:tree_app/core/constant/app_constant.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';

import '../widgets/brain_and_task_title.dart';

class GridItemTask extends StatelessWidget {
  const GridItemTask({
    super.key,
    required this.taskTitle,
    required this.taskDate,
    required this.taskDescription,
  });

  final String taskTitle;

  final String taskDate;

  final String taskDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      width: AppConstant.deviceWidth(context) / 1.3,
      height: 190.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xff6fa74f), // درجة وسط بين الفاتح والغامق
            Color(0xff83b961), // اللون الأساسي
            Color(0xffa8dc8d), // فاتح جدًا - يعطي بداية مشرقة
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BrainAndTaskTitle(taskTitle: taskTitle),
          Spacing.verticalSpace(15),
          Text(
            taskDescription,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 16),
              fontWeight: FontWeightHelper.regular,
              color: Colors.white,
            ),
          ),
          Spacing.verticalSpace(16),
          Text(
            taskDate,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 16),
              fontWeight: FontWeightHelper.semiBold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

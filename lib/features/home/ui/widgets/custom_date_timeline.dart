import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/config/themes/font_weight.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';

class CustomDateTimeline extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const CustomDateTimeline({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: selectedDate,
      onDateChange: onDateChanged,
      activeColor: AppColors.kPrimaryColor,
      headerProps: EasyHeaderProps(
        dateFormatter: DateFormatter.custom(
          DateFormat('d MMM yyyy').format(selectedDate),
        ),
        showHeader: false,
      ),
      dayProps: EasyDayProps(
        activeBorderRadius: 32.0,
        inactiveBorderRadius: 32.0,
        inactiveDayDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColors.kGrayColor.withOpacity(.2),
        ),
        todayStyle: DayStyle(borderRadius: 32),
        activeDayStyle: DayStyle(
          dayNumStyle: TextStyle(
            color: AppColors.kWhiteColor,
            fontSize: getResponsiveFontSize(context, fontSize: 18),
            fontWeight: FontWeightHelper.semiBold,
          ),
          dayStrStyle: TextStyle(color: AppColors.kWhiteColor),
          monthStrStyle: TextStyle(color: AppColors.kWhiteColor),
        ),
      ),
      timeLineProps: const EasyTimeLineProps(
        hPadding: 16.0,
        separatorPadding: 16.0,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tree_app/features/get_started/ui/screens/user_info.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../config/themes/font_weight.dart';
import '../../../../core/animation/fade_transaction.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/methods/get_responsive_text/responsive_text.dart';

class GetStartedContent extends StatelessWidget {
  const GetStartedContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.appName,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 25),
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeightHelper.bold,
                ),
          ),
          Spacing.verticalSpace(10),
          Text(
            AppLocalizations.of(context)!.getStartedDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 16),
                  color: AppColors.kGreyColor,

                  height: 1.5,
                  fontWeight: FontWeightHelper.regular,
                ),
          ),
          Spacing.verticalSpace(20),
          CustomButton(
            color: AppColors.kPrimaryColor,
            height: 50.h,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 18),
                  fontWeight: FontWeightHelper.semiBold,
                  color: AppColors.kWhiteColor,
                ),
            onPressed: () {
              Navigator.push(
                  context, SecondFadeTransaction(const UserInfo()));
            },
            text: AppLocalizations.of(context)!.getStarted,
          ),
        ],
      ),
    );
  }
}

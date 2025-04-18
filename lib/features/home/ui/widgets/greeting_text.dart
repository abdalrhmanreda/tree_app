import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/config/themes/font_weight.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';

class GreetingText extends StatelessWidget {
  final String userName;

  const GreetingText({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: getResponsiveFontSize(context, fontSize: 22),
          fontWeight: FontWeightHelper.regular,
          color: AppColors.kBlackColor,
        ),
        children: [
          TextSpan(text: '${AppLocalizations.of(context)!.hello} '),
          TextSpan(
            text: userName,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 22),
              fontWeight: FontWeightHelper.semiBold,
              color: AppColors.kBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}

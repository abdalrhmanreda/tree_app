import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tree_app/core/helpers/spacing.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../config/themes/font_weight.dart';
import '../../../../core/methods/get_responsive_text/responsive_text.dart';

class BuildTaskItemFeild extends StatelessWidget {
  const BuildTaskItemFeild({
    super.key,
    required this.title,
    required this.controller,
    this.hint,
    this.label,
    required this.height,
    this.minLine,
    this.maxLine,
    this.suffixIcon,
    this.suffixPressed,
    this.onTap,
    this.prefixIcon,
    this.keyboardType,
    this.scrollController,
  });

  final String title;
  final String? hint;
  final String? label;
  final VoidCallback? suffixPressed;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final double? height;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final int? maxLine;
  final int? minLine;
  final TextInputType? keyboardType; // Fixed here
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 16),
              fontWeight: FontWeightHelper.semiBold,
              color: AppColors.kBlackColor,
            ),
          ),
          Spacing.verticalSpace(10), // Ensure height is not null
          TextFormField(
            controller: controller,
            scrollController: scrollController,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              suffixIcon:
                  suffixIcon != null
                      ? IconButton(
                        icon: Icon(suffixIcon),
                        onPressed: suffixPressed,
                      )
                      : null,
              labelText: label,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeightHelper.regular,
                color: AppColors.kGreyColor,
              ),
              hintText: hint,
              alignLabelWithHint: true,
              // Helps align the label if multiline
              contentPadding: EdgeInsets.symmetric(
                vertical: minLine != null && minLine! > 1 ? 16.h : 12.h,
                horizontal: 12.w,
              ),
            ),
            keyboardType: keyboardType,
            // Use keyboardType instead of type
            maxLines: maxLine,
            minLines: minLine,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Field must not be empty';
              }
              return null; // Validation return null if it's valid
            },
            onTap: onTap,

            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus(); // Dismiss keyboard on submit
            },
          ),
        ],
      ),
    );
  }
}

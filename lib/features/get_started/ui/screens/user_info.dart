import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: AppConstant.deviceHeight(context) / 2.5,
                  width: AppConstant.deviceWidth(context),
                  child: Lottie.asset(Assets.imagesHello),
                ),
                Spacing.verticalSpace(10),
                Text(
                  AppLocalizations.of(context)!.enterNameDescription,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: getResponsiveFontSize(context, fontSize: 19),
                    fontWeight: FontWeightHelper.regular,
                    color: AppColors.kGreyColor,
                  ),
                ),
                Spacing.verticalSpace(10),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.nameRequired;
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeightHelper.regular,
                    color: AppColors.kBlackColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.kPrimaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.kGrayColor),
                    ),

                    hintText: AppLocalizations.of(context)!.enterName,
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.kGrayColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 18.h,
                      horizontal: 20.w,
                    ),
                  ),
                ),
                Spacing.verticalSpace(30),
                CustomButton(
                  color: AppColors.kPrimaryColor,
                  height: 50.h,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: getResponsiveFontSize(context, fontSize: 18),
                    fontWeight: FontWeightHelper.semiBold,
                    color: AppColors.kWhiteColor,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Use nameController.text here
                      SharedPrefService().setString("userName" , nameController.text).then((v){
                        SharedPrefService().setBool('isStart', true);
                        Navigator.push(
                            context, SecondFadeTransaction(const HomeScreen()));
                      });
                      // Navigate or save name...
                    }
                  },
                  text: AppLocalizations.of(context)!.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../generated/assets.dart';
import '../widgets/get_started_content.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 20.h,
        ),
        child: Column(
          children: [
            const Expanded(
              child: RiveAnimation.asset(
                Assets.imagesTree,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Spacing.verticalSpace(20),
            const GetStartedContent(),
          ],
        ),
      ),
    );
  }
}

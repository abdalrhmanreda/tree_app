import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tree_app/core/helpers/spacing.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../generated/assets.dart';
import '../../logic/task_cubit.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder:
          (context, index) => Slidable(
            // Specify a key if the Slidable is dismissible.
            key: const ValueKey(0),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  // An action can be bigger than the others.
                  flex: 4,

                  onPressed: (context) {},
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Iconsax.trash_outline,
                  label: 'delete',
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
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
                  Column(
                    children: [
                      Spacing.verticalSpace(10),
                      Text(
                        context.read<AppCubit>().tasks[index]['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kBlackColor,
                        ),
                      ),
                      Spacing.verticalSpace(10),
                      Text(
                        context.read<AppCubit>().tasks[index]['date'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      separatorBuilder: (context, index) => Spacing.verticalSpace(15),
      itemCount: context.read<AppCubit>().tasks.length,
    );
  }
}

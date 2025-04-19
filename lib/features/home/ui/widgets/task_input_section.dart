// task_input_section.dart
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:tree_app/config/colors/app_colors.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/features/home/ui/widgets/build_task_feild_item.dart';

import '../../../../config/themes/font_weight.dart';
import '../../../../core/methods/get_responsive_text/responsive_text.dart';

class TaskInputSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final List<String> categories;
  final int selectedCategoryIndex;
  final Function(int) onCategoryChanged;

  const TaskInputSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.startTimeController,
    required this.endTimeController,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTaskItemFeild(
          height: 10,
          title: 'Task Title',
          hint: 'Enter Task Title',
          keyboardType: TextInputType.text,
          controller: titleController,
        ),
        Spacing.verticalSpace(15),
        Text(
          'Select Category',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, fontSize: 16),
            fontWeight: FontWeightHelper.semiBold,
            color: AppColors.kBlackColor,
          ),
        ),
        Spacing.verticalSpace(10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: List.generate(categories.length, (i) {
            final isSelected = selectedCategoryIndex == i;
            return GestureDetector(
              onTap: () => onCategoryChanged(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.kPrimaryColor
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  categories[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black45,
                  ),
                ),
              ),
            );
          }),
        ),
        Spacing.verticalSpace(15),
        BuildTaskItemFeild(
          title: 'Description',
          scrollController: ScrollController(),
          hint: 'Description',
          controller: descriptionController,
          height: 40,
          maxLine: null,
          minLine: null,
        ),
        Spacing.verticalSpace(15),
        Row(
          children: [
            Expanded(
              child: BuildTaskItemFeild(
                title: 'Start Time',
                controller: startTimeController,
                hint: 'Start Time',
                height: 40,
                maxLine: 1,
                suffixIcon: IconlyBroken.time_circle,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      startTimeController.text = value.format(context);
                    }
                  });
                },
                minLine: 1,
              ),
            ),
            Spacing.horizontalSpace(15),
            Expanded(
              child: BuildTaskItemFeild(
                title: 'End Time',
                controller: endTimeController,
                hint: 'End Time',
                suffixIcon: IconlyBroken.time_circle,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      endTimeController.text = value.format(context);
                    }
                  });
                },
                height: 40,
                maxLine: 1,
                minLine: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

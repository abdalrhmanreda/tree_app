import 'package:flutter/material.dart';

import '../../../../config/colors/app_colors.dart';

class TaskFilterChips extends StatelessWidget {
  final int selectedIndex;
  final List<String> taskList;
  final Function(int) onSelected;

  const TaskFilterChips({
    Key? key,
    required this.selectedIndex,
    required this.taskList,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: List.generate(taskList.length, (i) {
        final isSelected = selectedIndex == i;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppColors.kPrimaryColor : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              taskList[i],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black45,
              ),
            ),
          ),
        );
      }),
    );
  }
}

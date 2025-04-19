import 'package:flutter/material.dart';
import 'package:tree_app/core/helpers/spacing.dart';

import '../../logic/task_cubit.dart';
import 'grid_item_task.dart';

class TaskHorizontalList extends StatelessWidget {
  const TaskHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = AppCubit.get(context).tasks;
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (context, index) => Spacing.horizontalSpace(15),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GridItemTask(
            taskTitle: task['title'],
            taskDate: task['date'],
            taskDescription: task['description'],
          );
        },
      ),
    );
  }
}

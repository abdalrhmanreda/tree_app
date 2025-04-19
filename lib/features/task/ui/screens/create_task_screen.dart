import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tree_app/core/animation/fade_transaction.dart';
import 'package:tree_app/core/components/custom_button.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/features/home/ui/screens/home_screen.dart';
import 'package:tree_app/features/home/ui/widgets/custom_date_timeline.dart';
import 'package:tree_app/features/task/logic/task_cubit.dart';
import 'package:tree_app/features/task/logic/task_state.dart';

import '../../../../core/components/toast.dart';
import '../../../home/ui/widgets/task_input_section.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  DateTime selectedDate = DateTime.now();

  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final categoryController = TextEditingController();

  final List<String> categories = [
    'Study',
    'Reading',
    'Meetings',
    'Shopping',
    'Programming',
    'Personal',
    'Workout',
  ];

  int selectedCategoryIndex = 0;

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),

      child: BlocConsumer<AppCubit, AppStates>(
        builder:
            (context, state) => Scaffold(
              appBar: AppBar(title: const Text('Create Task')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDateTimeline(
                      selectedDate: selectedDate,
                      onDateChanged: (newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                    ),

                    Spacing.verticalSpace(15),

                    TaskInputSection(
                      titleController: taskTitleController,
                      descriptionController: taskDescriptionController,
                      startTimeController: startTimeController,
                      endTimeController: endTimeController,
                      categories: categories,
                      selectedCategoryIndex: selectedCategoryIndex,
                      onCategoryChanged: (i) {
                        setState(() {
                          selectedCategoryIndex = i;
                          categoryController.text = categories[i];
                        });
                      },
                    ),

                    Spacing.verticalSpace(15),

                    CustomButton(
                      onPressed: () {
                        // Submit task logic here
                        AppCubit.get(context).insertIntoDataBase(
                          title: taskTitleController.text,
                          category: categories[selectedCategoryIndex],
                          date: DateFormat(
                            'd MMMM. EEEE',
                            'en',
                          ).format(selectedDate),
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                          description: taskDescriptionController.text,
                        );
                      },
                      text: 'Create Task',
                    ),
                  ],
                ),
              ),
            ),
        listener: (context, state) {
          if (state is InsertIntoDataBaseSuccessState) {
            showToast(
              context: context,
              title: 'Task Created Successfully',
              description: 'You just created a task to your list',
            );
            Navigator.push(context, SecondFadeTransaction(HomeScreen()));
          }
        },
      ),
    );
  }
}

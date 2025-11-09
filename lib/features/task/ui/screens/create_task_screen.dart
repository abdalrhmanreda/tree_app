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

  void _validateAndSubmit(BuildContext context) {
    if (taskTitleController.text.trim().isEmpty) {
      showToast(
        context: context,
        title: 'Validation Error',
        description: 'Please enter a task title',
      );
      return;
    }

    if (startTimeController.text.trim().isEmpty ||
        endTimeController.text.trim().isEmpty) {
      showToast(
        context: context,
        title: 'Validation Error',
        description: 'Please select start and end times',
      );
      return;
    }

    AppCubit.get(context).insertIntoDataBase(
      title: taskTitleController.text,
      category: categories[selectedCategoryIndex],
      date: DateFormat('d MMMM. EEEE', 'en').format(selectedDate),
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      description: taskDescriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey[800],
            title: const Text(
              'Create Task',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Selection Card
                Card(
                  elevation: 2,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Select Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomDateTimeline(
                          selectedDate: selectedDate,
                          onDateChanged: (newDate) {
                            setState(() {
                              selectedDate = newDate;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Spacing.verticalSpace(20),

                // Task Details Card
                Card(
                  elevation: 2,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Task Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                      ],
                    ),
                  ),
                ),

                Spacing.verticalSpace(24),

                // Create Button with Loading State
                state is InsertIntoDataBaseLoadingState
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
                    : CustomButton(
                  onPressed: () => _validateAndSubmit(context),
                  text: 'Create Task',
                ),

                Spacing.verticalSpace(20),
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
            Navigator.pushReplacement(
              context,
              SecondFadeTransaction(const HomeScreen()),
            );
          } else if (state is InsertIntoDataBaseErrorState) {
            showToast(
              context: context,
              title: 'Error',
              description: 'Failed to create task. Please try again.',
            );
          }
        },
      ),
    );
  }
}
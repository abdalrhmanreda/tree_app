import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_app/core/cache/shared_pref.dart';
import 'package:tree_app/core/components/progress_indector.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/features/home/ui/widgets/greeting_text.dart';
import 'package:tree_app/features/task/ui/widgets/task_list.dart';
import 'package:tree_app/features/task/ui/screens/create_task_screen.dart';

import '../../logic/task_cubit.dart';
import '../../logic/task_state.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/task_horz_list.dart';

class HomeTasksScreen extends StatefulWidget {
  const HomeTasksScreen({super.key});

  @override
  State<HomeTasksScreen> createState() => _HomeTasksScreenState();
}

class _HomeTasksScreenState extends State<HomeTasksScreen> {
  late String userName;
  int selectedIndex = 0;

  List<String> taskList = ['My Tasks', 'Completed', 'In progress'];

  @override
  void initState() {
    super.initState();
    userName = SharedPrefService().getString('userName')!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => state is GetDataFromDatabaseSuccessState
            ? Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
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
            title: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GreetingText(userName: userName),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<AppCubit>().createDataBase();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Filter Section with Card
                        Card(
                          elevation: 2,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            child: TaskFilterChips(
                              selectedIndex: selectedIndex,
                              taskList: taskList,
                              onSelected: (index) {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        Spacing.verticalSpace(24),

                        // Section Header
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Quick Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        // Horizontal Task List
                        TaskHorizontalList(),

                        Spacing.verticalSpace(28),

                        // Tasks List Header with divider
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                taskList[selectedIndex],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 1.5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor.withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Spacing.verticalSpace(16),
                      ],
                    ),
                  ),
                ),

                // Tasks List as Sliver
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: TasksList(),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
          // Floating Action Button for Adding Tasks
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTaskScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded, size: 28),
            label: const Text(
              'Add Task',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            elevation: 4,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        )
            : const Scaffold(
          body: Center(
            child: CustomLoadingIndicator(),
          ),
        ),
      ),
    );
  }
}
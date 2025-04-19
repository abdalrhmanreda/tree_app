import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_app/core/cache/shared_pref.dart';
import 'package:tree_app/core/components/progress_indector.dart';
import 'package:tree_app/core/helpers/spacing.dart';
import 'package:tree_app/features/home/ui/widgets/greeting_text.dart';
import 'package:tree_app/features/task/ui/widgets/task_list.dart';

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
        builder:
            (context, state) =>
                state is GetDataFromDatabaseSuccessState
                    ? Scaffold(
                      appBar: AppBar(
                        title: GreetingText(userName: userName),
                        automaticallyImplyLeading: false,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TaskFilterChips(
                                selectedIndex: selectedIndex,
                                taskList: taskList,
                                onSelected: (index) {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              ),
                              Spacing.verticalSpace(25),
                              TaskHorizontalList(),
                              Spacing.verticalSpace(25),
                              TasksList(),
                            ],
                          ),
                        ),
                      ),
                    )
                    : CustomLoadingIndicator(),
      ),
    );
  }
}

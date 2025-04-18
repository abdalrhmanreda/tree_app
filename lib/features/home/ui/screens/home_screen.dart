import 'package:flutter/material.dart';
import 'package:tree_app/core/cache/shared_pref.dart';

import '../../../foucs_time/ui/screens/foucs_time_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userName;
  DateTime selectedDate = DateTime.now();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    userName = SharedPrefService().getString('userName')!;
  }

  List<Widget> screens = [
    const FocusTimeScreen(),
    const FocusTimeScreen(),
    const FocusTimeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTabChange: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}

/*
* Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingText(userName: userName),
            Spacing.verticalSpace(25),
            CustomDateTimeline(
              selectedDate: selectedDate,
              onDateChanged: (date) => setState(() => selectedDate = date),
            ),
          ],
        ),
      )
* */

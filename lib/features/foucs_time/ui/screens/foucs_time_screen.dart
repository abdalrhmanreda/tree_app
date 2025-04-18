import 'package:flutter/material.dart';
import 'package:tree_app/core/cache/shared_pref.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';
import 'package:tree_app/features/foucs_time/ui/screens/tree_screen.dart';

import '../../../../core/animation/fade_transaction.dart';

class FocusTimeScreen extends StatefulWidget {
  const FocusTimeScreen({super.key});

  @override
  State<FocusTimeScreen> createState() => _FocusTimeScreenState();
}

class _FocusTimeScreenState extends State<FocusTimeScreen> {
  List<int> focusTimes = [];

  @override
  void initState() {
    super.initState();
    _loadFocusTimes();
  }

  Future<void> _loadFocusTimes() async {
    setState(() {
      focusTimes = SharedPrefService().getFocusTimes();
    });
  }

  Future<void> _addTimeDialog() async {
    final controller = TextEditingController();
    int? newTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Focus Time'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter minutes",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: (value) => newTime = int.tryParse(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newTime != null && newTime! > 0) {
                  await SharedPrefService().addFocusTime(newTime!);
                  _loadFocusTimes();
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.7,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            ...focusTimes.map(
              (time) => GestureDetector(
                onTap: () {
                  // Do something when a time is selected
                  Navigator.push(
                    context,
                    SecondFadeTransaction(TreeScreen(min: time)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$time',
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(
                              context,
                              fontSize: 26,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'min',
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(
                              context,
                              fontSize: 16,
                            ),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _addTimeDialog,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Icon(Icons.add, size: 30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

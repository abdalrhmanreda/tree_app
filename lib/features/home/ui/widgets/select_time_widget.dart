import 'package:flutter/material.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../core/methods/get_responsive_text/responsive_text.dart';

class SelectTimeWidget extends StatefulWidget {
  const SelectTimeWidget({super.key});

  @override
  _SelectTimeWidgetState createState() => _SelectTimeWidgetState();
}

class _SelectTimeWidgetState extends State<SelectTimeWidget> {
  // قائمة الأوقات الممكنة
  final List<String> timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:30 PM',
    '01:30 PM',
    '03:00 PM',
    '04:30 PM',
  ];

  // المتغير لتخزين الوقت المحدد
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0, // المسافة بين الأزرار أفقياً
      runSpacing: 10.0, // المسافة بين الأزرار عمودياً
      children:
          timeSlots.map((time) {
            final isSelected = time == selectedTime;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTime = time;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.kOurServicesColor
                          : Colors.grey[200],
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.kPrimaryColor
                            : Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, fontSize: 16),
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

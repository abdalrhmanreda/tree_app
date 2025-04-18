import 'package:flutter/material.dart';

import 'gender_option.dart';

class GenderSelector extends StatefulWidget {
  final Function(String gender) onSelected;
  final String? initialGender;

  const GenderSelector({
    super.key,
    required this.onSelected,
    this.initialGender,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender;
  }

  void _onGenderTap(String gender) {
    setState(() => selectedGender = gender);
    widget.onSelected(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GenderOption(
          gender: 'male',
          imagePath: 'assets/male.png',
          isSelected: selectedGender == 'male',
          onTap: _onGenderTap,
        ),
        const SizedBox(width: 20),
        GenderOption(
          gender: 'female',
          imagePath: 'assets/female.png',
          isSelected: selectedGender == 'female',
          onTap: _onGenderTap,
        ),
      ],
    );
  }
}

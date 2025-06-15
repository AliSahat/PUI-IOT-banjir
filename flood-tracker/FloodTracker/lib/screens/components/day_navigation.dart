// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DayNavigation extends StatelessWidget {
  final List<String> days;
  final String selectedDay;
  final Color selectedDayColor;
  final Color cardBackgroundColor;
  final ValueChanged<String> onDaySelected;

  const DayNavigation({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.selectedDayColor,
    required this.cardBackgroundColor,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day == selectedDay;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  onDaySelected(day);
                }
              },
              backgroundColor:
                  isSelected
                      ? selectedDayColor
                      : cardBackgroundColor.withOpacity(0.5),
              selectedColor: selectedDayColor,
              labelStyle: TextStyle(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? selectedDayColor : Colors.transparent,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
          );
        },
      ),
    );
  }
}

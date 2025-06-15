// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color selectedColor;

  const PageIndicators({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index == currentPage
                    ? selectedColor
                    : Colors.grey.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DashboardNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final String title;

  const DashboardNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color:
                currentPage > 0 ? Colors.white : Colors.white.withOpacity(0.3),
            size: 20,
          ),
          onPressed: currentPage > 0 ? onPreviousPage : null,
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color:
                currentPage < totalPages - 1
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
            size: 20,
          ),
          onPressed: currentPage < totalPages - 1 ? onNextPage : null,
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
      ],
    );
  }
}

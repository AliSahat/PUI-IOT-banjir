import 'package:flutter/material.dart';

class DashboardConstants {
  static const int totalPages = 3; // Update back to 3
  static const double cardHeight = 380.0;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOut;

  static const List<String> pageTitles = [
    'Status Hari Ini',
    'Grafik Ketinggian Air',
    'Peringatan Dini',
    // Remove 'Emergency' from the list
  ];
}
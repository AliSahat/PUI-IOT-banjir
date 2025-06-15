// ignore_for_file: unused_import

import 'package:deteksi_banjir/screens/getstard_screen.dart'
    show GetStartedScreen;
import 'package:deteksi_banjir/screens/kontak_darurat.dart';
import 'package:deteksi_banjir/screens/navbar_screen.dart';
import 'package:deteksi_banjir/screens/news_screen.dart';
import 'package:deteksi_banjir/screens/weather_screen.dart';
import 'package:deteksi_banjir/services/notification/notification_services.dart';
import 'package:deteksi_banjir/utils/id_indonesian.dart';
import 'package:flutter/material.dart';
import 'screens/flood_screen.dart';
import 'screens/get_started_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // Initialize notifications
  initIndonesianLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deteksi Banjir',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A2C3D),
        primaryColor: const Color(0xFF303030),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF303030),
          indicatorColor: const Color(0xFF171717),
        ),
      ),
      initialRoute: '/getstarted',
      routes: {
        '/getstarted': (context) => const GetStartedScreen(),
        '/': (context) => const NavbarScreen(),
        '/flood': (context) => const FloodScreen(),
        '/weather': (context) => const WeatherApp(),
        '/news': (context) => const NewsScreen(),
        '/emergency': (context) => const KontakDarurat(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

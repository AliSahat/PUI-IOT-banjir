// ignore_for_file: deprecated_member_use

import 'package:deteksi_banjir/screens/kontak_darurat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deteksi_banjir/screens/chat_screen.dart';
import 'package:deteksi_banjir/screens/flood_screen.dart';
import 'package:deteksi_banjir/screens/news_screen.dart';
import 'package:deteksi_banjir/screens/weather_screen.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> 
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static final List<Widget> _pages = <Widget>[
    const FloodScreen(),
    const WeatherApp(),
    const NewsScreen(),
    const ChatScreen(),
    const KontakDarurat(),
  ];

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.water_drop_outlined,
      selectedIcon: Icons.water_drop,
      label: 'Flood',
      gradient: const LinearGradient(
        colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
      ),
    ),
    NavItem(
      icon: Icons.wb_sunny_outlined,
      selectedIcon: Icons.wb_sunny,
      label: 'Weather',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
      ),
    ),
    NavItem(
      icon: Icons.newspaper_outlined,
      selectedIcon: Icons.newspaper,
      label: 'News',
      gradient: const LinearGradient(
        colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
      ),
    ),
    NavItem(
      icon: Icons.forum_outlined,
      selectedIcon: Icons.forum,
      label: 'Chat',
      gradient: const LinearGradient(
        colors: [Color(0xFFBA68C8), Color(0xFF9C27B0)],
      ),
    ),
    NavItem(
      icon: Icons.emergency_outlined,
      selectedIcon: Icons.emergency,
      label: 'Emergency',
      gradient: const LinearGradient(
        colors: [Color(0xFFE57373), Color(0xFFD32F2F)],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex != index) {
      
      HapticFeedback.lightImpact();
      
      setState(() {
        _selectedIndex = index;
      });
      
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _pages,
        ),
      ),
      extendBody: true, 
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.95),
              elevation: 0,
              height: 65,
              indicatorColor: Colors.transparent,
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                final isSelected = states.contains(MaterialState.selected);
                return TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[400],
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              animationDuration: const Duration(milliseconds: 400),
              destinations: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = _selectedIndex == index;
                
                return NavigationDestination(
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    padding: EdgeInsets.all(isSelected ? 12 : 8),
                    decoration: BoxDecoration(
                      gradient: isSelected ? item.gradient : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: item.gradient.colors.first.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: AnimatedScale(
                      scale: isSelected ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        item.icon,
                        color: isSelected ? Colors.white : Colors.grey[400],
                        size: 22,
                      ),
                    ),
                  ),
                  selectedIcon: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: item.gradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: item.gradient.colors.first.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedScale(
                      scale: 1.1,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        item.selectedIcon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  label: item.label,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final LinearGradient gradient;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.gradient,
  });
}
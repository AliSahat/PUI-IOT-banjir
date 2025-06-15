// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'Weather_Forecast.dart';
import 'kelola_kota.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const WeatherHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  final String cityName;
  const WeatherHomePage({super.key, this.cityName = "Yogyakarta"});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFF0F0F23)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Modern App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final selectedCity = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const CityManagementScreen(),
                                ),
                              );
                              if (selectedCity != null &&
                                  selectedCity.isNotEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => WeatherHomePage(
                                          cityName: selectedCity,
                                        ),
                                  ),
                                );
                              }
                            },
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.cityName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Indonesia',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            6,
                          ), // Lebih kecil dari sebelumnya
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Lebih kecil dan pas
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 1,
                            ),
                          ),
                          child: GestureDetector(
                            onTapDown: (details) {
                              final RenderBox overlay =
                                  Overlay.of(context).context.findRenderObject()
                                      as RenderBox;
                              showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                  details.globalPosition & const Size(40, 40),
                                  Offset.zero & overlay.size,
                                ),
                                items: [
                                  PopupMenuItem(
                                    value: 'share',
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.share_rounded,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Bagikan'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'settings',
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.settings_rounded,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Pengaturan'),
                                      ],
                                    ),
                                  ),
                                ],
                              ).then((value) {
                                if (value == 'share') {
                                  // Tambahkan aksi share di sini
                                } else if (value == 'settings') {
                                  // Tambahkan aksi pengaturan di sini
                                }
                              });
                            },
                            child: const Icon(
                              Icons.more_vert_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weather Animation Area
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Weather Icon with Animation
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.3),
                                Colors.cyan.withOpacity(0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.cloud_queue_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Temperature Display
                        ShaderMask(
                          shaderCallback:
                              (bounds) => const LinearGradient(
                                colors: [Colors.white, Colors.blue],
                              ).createShader(bounds),
                          child: const Text(
                            '25°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 72,
                              fontWeight: FontWeight.w200,
                              letterSpacing: -4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Hujan Sedang',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Terasa seperti 27°',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weather Details Card (Wind & UV)
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.air_rounded,
                              title: 'Angin',
                              value: '15 km/h',
                              subtitle: 'Barat Daya',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.wb_sunny_outlined,
                              title: 'UV Index',
                              value: '6',
                              subtitle: 'Tinggi',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Modern Weather Cards
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header with icon and title
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4A9B8E,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFF4A9B8E),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Ramalan 3 Hari',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Weather forecast items
                          _buildWeatherItem(
                            icon: Icons.cloud_rounded,
                            day: 'Hari ini',
                            condition: 'Hujan sedang',
                            temp: '33° / 23°',
                            isToday: true,
                          ),

                          const SizedBox(height: 12),

                          _buildWeatherItem(
                            icon: Icons.thunderstorm_rounded,
                            day: 'Besok',
                            condition: 'Hujan',
                            temp: '30° / 21°',
                          ),

                          const SizedBox(height: 12),

                          _buildWeatherItem(
                            icon: Icons.wb_sunny_rounded,
                            day: 'Lusa',
                            condition: 'Cerah berawan',
                            temp: '32° / 24°',
                          ),

                          const SizedBox(height: 20),

                          // Modern CTA Button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const WeatherForecastPage(),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4A9B8E),
                                    Color(0xFF6BB6FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF4A9B8E,
                                    ).withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Lihat Detail Ramalan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherItem({
    required IconData icon,
    required String day,
    required String condition,
    required String temp,
    bool isToday = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isToday ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border:
            isToday ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getIconColor(icon).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _getIconColor(icon), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  condition,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            temp,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.cloud_rounded:
        return Colors.grey;
      case Icons.thunderstorm_rounded:
        return Colors.purple;
      case Icons.wb_sunny_rounded:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

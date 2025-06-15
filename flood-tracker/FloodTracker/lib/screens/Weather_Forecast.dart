// ignore_for_file: file_names, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData.dark(),
      home: const WeatherForecastPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Custom painter for lightning effect
class LightningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFE135)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    Path path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.4);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(size.width * 0.3, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.6);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WeatherForecastPage extends StatelessWidget {
  const WeatherForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ramalan 3 Hari :',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // Kemarin - Terang
            WeatherCard(
              day: 'Kemarin',
              weather: 'Terang',
              highTemp: '35°',
              lowTemp: '29°',
              weatherIcon: _buildSunnyIcon(),
              backgroundColor: const Color(0xFF7DB4A8),
            ),
            
            const SizedBox(height: 16),
            
            // Hari ini - Hujan
            WeatherCard(
              day: 'Hari ini',
              weather: 'Hujan',
              highTemp: '35°',
              lowTemp: '29°',
              weatherIcon: _buildRainyIcon(),
              backgroundColor: const Color(0xFF6B9B95),
            ),
            
            const SizedBox(height: 16),
            
            // Besok - Mendung
            WeatherCard(
              day: 'Besok',
              weather: 'Mendung',
              highTemp: '35°',
              lowTemp: '29°',
              weatherIcon: _buildCloudyIcon(),
              backgroundColor: const Color(0xFF8A9BA8),
            ),
            
            const SizedBox(height: 16),
            
            // Minggu - Terang
            WeatherCard(
              day: 'Minggu',
              weather: 'Terang',
              highTemp: '35°',
              lowTemp: '29°',
              weatherIcon: _buildSunnyIcon(),
              backgroundColor: const Color(0xFF7DB4A8),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Sunny weather icon with gradient
  static Widget _buildSunnyIcon() {
    return Container(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow effect
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFD700).withOpacity(0.3),
                  Colors.transparent,
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          // Sun rays with modern design
          ...List.generate(12, (index) {
            final angle = (index * 30) * (3.14159 / 180);
            return Transform.rotate(
              angle: angle,
              child: Container(
                width: 4,
                height: 20,
                margin: const EdgeInsets.only(bottom: 35),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Sun core with gradient
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFE55C),
                  Color(0xFFFFD700),
                  Color(0xFFFFA500),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.6),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // Sun face
          Container(
            width: 35,
            height: 35,
            child: const Icon(
              Icons.wb_sunny,
              color: Color(0xFFFFF8DC),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // Modern Rainy weather icon with animations
  static Widget _buildRainyIcon() {
    return Container(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main cloud with gradient
          Positioned(
            top: 10,
            child: Container(
              width: 55,
              height: 35,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A5568), Color(0xFF2D3748)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // Secondary cloud
          Positioned(
            top: 5,
            right: 8,
            child: Container(
              width: 30,
              height: 25,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF718096), Color(0xFF4A5568)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          // Modern rain drops
          ...List.generate(5, (index) {
            return Positioned(
              bottom: 5 + (index * 2),
              left: 20 + (index * 8),
              child: Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4299E1), Color(0xFF2B6CB0)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4299E1).withOpacity(0.5),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          }),
          // Lightning effect (optional)
          Positioned(
            bottom: 20,
            right: 15,
            child: Container(
              width: 8,
              height: 15,
              child: CustomPaint(
                painter: LightningPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modern Cloudy weather icon with layered design
  static Widget _buildCloudyIcon() {
    return Container(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background cloud
          Positioned(
            top: 15,
            right: 5,
            child: Container(
              width: 45,
              height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          // Front main cloud
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              width: 50,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE5E7EB), Color(0xFF9CA3AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // Small accent cloud
          Positioned(
            top: 25,
            right: 15,
            child: Container(
              width: 20,
              height: 15,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF3F4F6), Color(0xFFD1D5DB)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Wind lines for movement effect
          ...List.generate(3, (index) {
            return Positioned(
              bottom: 10 + (index * 5),
              left: 15 + (index * 3),
              child: Container(
                width: 15 - (index * 2),
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF9CA3AF).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String day;
  final String weather;
  final String highTemp;
  final String lowTemp;
  final Widget weatherIcon;
  final Color backgroundColor;

  const WeatherCard({
    super.key,
    required this.day,
    required this.weather,
    required this.highTemp,
    required this.lowTemp,
    required this.weatherIcon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Day and Weather info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$day : $weather',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$highTemp / $lowTemp',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Right side - Weather icon
          Container(
            width: 80,
            height: 80,
            child: weatherIcon,
          ),
        ],
      ),
    );
  }
}
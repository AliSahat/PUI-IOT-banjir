import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deteksi_banjir/utils/dashboard_constants.dart';
import 'package:deteksi_banjir/screens/components/dashboard/pages/status_page.dart';
import 'package:deteksi_banjir/screens/components/dashboard/pages/alert_page.dart';
import 'package:deteksi_banjir/services/iot_services.dart';
import 'package:deteksi_banjir/utils/logger_services.dart';
import 'package:deteksi_banjir/models/sensor_data.dart';

class StatusDashboardCard extends StatefulWidget {
  final String statusValue;
  final String statusLevel;
  final Color statusColor;
  final String curahHujan;
  final String trenValue;
  final String prediksiText;
  final String alertLevelValue;

  const StatusDashboardCard({
    super.key,
    required this.statusValue,
    required this.statusLevel,
    required this.statusColor,
    required this.curahHujan,
    required this.trenValue,
    required this.prediksiText,
    required this.alertLevelValue,
  });

  @override
  State<StatusDashboardCard> createState() => _StatusDashboardCardState();
}

class _StatusDashboardCardState extends State<StatusDashboardCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<WaterLevelData> _waterLevelData = [];
  SensorData? _latestData;
  bool _isLoading = true;
  double _minLevel = 0;
  double _maxLevel = 100;
  double _avgLevel = 0;
  String _minTime = "00:00";
  String _maxTime = "00:00";

  Timer? _dataTimer;

  // Color Scheme
  // static const Color primaryBackground = Color(0xFF303030);
  static const Color secondaryBackground = Color(0xFF171717);
  static const Color textColor = Colors.white;
  static const Color disabledColor = Color(0xFF505050);
  static const Color chartLineColor = Color(0xFF3A86FF);
  static const Color chartFillColor = Color(0xFF1A3A86);
  static const Color gridLineColor = Color(0xFF404040);

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _startRealTimeUpdates();
  }

  Future<void> _fetchInitialData() async {
    try {
      final latestData = await ApiService.fetchLatestSensorData();

      if (latestData == null) {
        throw Exception("No sensor data available");
      }

      final double waterLevel = double.tryParse(latestData.payload) ?? 0.0;
      final List<WaterLevelData> data = [];

      data.add(
        WaterLevelData(waterLevel: waterLevel, timestamp: latestData.timestamp),
      );

      if (mounted) {
        setState(() {
          _waterLevelData = data;
          _latestData = latestData;
          _isLoading = false;
          _updateStatistics();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        LoggerService.error('Error loading water level data: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Could not connect to sensor server',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  void _startRealTimeUpdates() {
    _dataTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final newData = await ApiService.fetchLatestSensorData();

        if (newData != null && mounted) {
          final double waterLevel = double.tryParse(newData.payload) ?? 0.0;

          setState(() {
            _latestData = newData;

            _waterLevelData.add(
              WaterLevelData(
                waterLevel: waterLevel,
                timestamp: newData.timestamp,
              ),
            );

            if (_waterLevelData.length > 30) {
              _waterLevelData.removeAt(0);
            }

            _updateStatistics();
          });
        }
      } catch (e) {
        LoggerService.error('Error updating water level data: $e');
      }
    });
  }

  void _updateStatistics() {
    if (_waterLevelData.isEmpty) return;

    _minLevel = _waterLevelData
        .map((e) => e.waterLevel)
        .reduce((a, b) => a < b ? a : b);
    _maxLevel = _waterLevelData
        .map((e) => e.waterLevel)
        .reduce((a, b) => a > b ? a : b);
    _avgLevel =
        _waterLevelData.map((e) => e.waterLevel).reduce((a, b) => a + b) /
        _waterLevelData.length;

    final minData = _waterLevelData.firstWhere(
      (data) => data.waterLevel == _minLevel,
    );
    final maxData = _waterLevelData.firstWhere(
      (data) => data.waterLevel == _maxLevel,
    );

    _minTime =
        "${minData.timestamp.hour.toString().padLeft(2, '0')}:${minData.timestamp.minute.toString().padLeft(2, '0')}";
    _maxTime =
        "${maxData.timestamp.hour.toString().padLeft(2, '0')}:${maxData.timestamp.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dataTimer?.cancel();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < DashboardConstants.totalPages - 1) {
      _pageController.nextPage(
        duration: DashboardConstants.pageTransitionDuration,
        curve: DashboardConstants.pageTransitionCurve,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: DashboardConstants.pageTransitionDuration,
        curve: DashboardConstants.pageTransitionCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String waterStatus = widget.statusLevel;
    Color waterStatusColor = widget.statusColor;

    String currentWaterLevel = widget.statusValue;
    if (_latestData != null) {
      currentWaterLevel = "${_latestData!.payload} cm";

      final double waterLevel = double.tryParse(_latestData!.payload) ?? 0.0;
      if (waterLevel < 30) {
        waterStatus = "Danger";
        waterStatusColor = Colors.red;
      } else if (waterLevel < 50) {
        waterStatus = "Warning";
        waterStatusColor = Colors.orange;
      } else if (waterLevel < 70) {
        waterStatus = "Alert";
        waterStatusColor = Colors.yellow;
      } else {
        waterStatus = "Normal";
        waterStatusColor = Colors.green;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: _currentPage > 0 ? textColor : disabledColor,
                  size: 20,
                ),
                onPressed: _previousPage,
              ),
              Text(
                _getPageTitle(_currentPage),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      _currentPage < DashboardConstants.totalPages - 1
                          ? textColor
                          : disabledColor,
                  size: 20,
                ),
                onPressed: _nextPage,
              ),
            ],
          ),

          // Main content area
          // In the build method, update the PageView children:
          SizedBox(
            height: 420,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              // In status_dashboard_card.dart, update PageView children
              children: [
                StatusPage(
                  statusValue: currentWaterLevel,
                  statusLevel: waterStatus,
                  statusColor: waterStatusColor,
                  curahHujan: widget.curahHujan,
                  trenValue: widget.trenValue,
                  prediksiText: widget.prediksiText,
                  alertLevelValue: widget.alertLevelValue,
                ),
                _buildChartPage(),
                AlertPage(
                  statusColor: waterStatusColor,
                  statusLevel: waterStatus,
                ),
                // Remove EmergencyPage from here
              ],
            ),
          ),

          // Page indicator
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(DashboardConstants.totalPages, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      index == _currentPage ? waterStatusColor : disabledColor,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(int page) {
    return DashboardConstants.pageTitles[page];
  }

  Widget _buildChartPage() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: widget.statusColor),
      );
    }

    if (_waterLevelData.isEmpty) {
      return Center(
        child: Text(
          "No sensor data available",
          style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  "Min: ${_minLevel.toStringAsFixed(1)} cm",
                  _minTime,
                  Colors.green,
                ),
                _buildStatCard(
                  "Max: ${_maxLevel.toStringAsFixed(1)} cm",
                  _maxTime,
                  Colors.red,
                ),
                _buildStatCard(
                  "Avg: ${_avgLevel.toStringAsFixed(1)} cm",
                  "",
                  Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Chart area
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis labels
                SizedBox(
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '100',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '75',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '50',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '25',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chart
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(double.infinity, double.infinity),
                            painter: ChartGridPainter(lineColor: gridLineColor),
                          ),
                          CustomPaint(
                            size: const Size(double.infinity, double.infinity),
                            painter: WaterLevelChartPainter(
                              waterLevelData: _waterLevelData,
                              lineColor: chartLineColor,
                              fillColor: chartFillColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String time, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          if (time.isNotEmpty)
            Text(
              time,
              style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
            ),
        ],
      ),
    );
  }
}

class WaterLevelData {
  final double waterLevel;
  final DateTime timestamp;

  WaterLevelData({required this.waterLevel, required this.timestamp});
}

class ChartGridPainter extends CustomPainter {
  final Color lineColor;

  ChartGridPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // Horizontal lines
    for (int i = 0; i <= 4; i++) {
      final y = i * (size.height / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical lines
    for (int i = 0; i <= 5; i++) {
      final x = i * (size.width / 5);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterLevelChartPainter extends CustomPainter {
  final List<WaterLevelData> waterLevelData;
  final Color lineColor;
  final Color fillColor;

  WaterLevelChartPainter({
    required this.waterLevelData,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waterLevelData.isEmpty) return;

    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke;

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [fillColor.withOpacity(0.7), fillColor.withOpacity(0.3)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    double minLevel = waterLevelData
        .map((e) => e.waterLevel)
        .reduce((a, b) => a < b ? a : b);
    double maxLevel = waterLevelData
        .map((e) => e.waterLevel)
        .reduce((a, b) => a > b ? a : b);

    if ((maxLevel - minLevel).abs() < 10) {
      maxLevel = minLevel + 10;
    }

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < waterLevelData.length; i++) {
      final x = i * size.width / (waterLevelData.length - 1);
      double normalizedValue =
          (waterLevelData[i].waterLevel - minLevel) / (maxLevel - minLevel);
      final y = size.height * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(path, paint);

      final fillPath = Path.from(path);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      canvas.drawPath(fillPath, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WaterLevelChartPainter oldDelegate) {
    return oldDelegate.waterLevelData != waterLevelData;
  }
}

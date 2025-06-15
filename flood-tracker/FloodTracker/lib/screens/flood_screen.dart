// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:async';
import 'package:deteksi_banjir/services/notification/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'components/header_section.dart';
import 'components/day_navigation.dart';
import 'components/dashboard/pages/status_dashboard_card.dart';
import 'components/footer_section.dart';
import 'package:deteksi_banjir/services/weather_services.dart';
import 'package:deteksi_banjir/services/iot_services.dart';
import 'package:deteksi_banjir/models/sensor_data.dart';

class FloodScreen extends StatefulWidget {
  const FloodScreen({super.key});

  @override
  State<FloodScreen> createState() => _FloodScreenState();
}

class _FloodScreenState extends State<FloodScreen> {
  static const String lokasi = 'Sleman, Yogyakarta';
  String tanggalString = 'Loading...';
  String suhu = '--°';

  late List<String> _days;
  late String _selectedDay;
  int _selectedDayIndex = 0;

  String statusValue = '--';
  String statusLevel = 'Loading...';
  Color statusColor = Colors.grey;

  String curahHujan = '--';
  String trenValue = '+3 cm';
  String prediksiText = 'Stabil';
  String alertLevelValue = '70 cm';
  String lastUpdateText = 'Last Update: --:--:-- • Loading...';

  final Color _cardBackgroundColor = const Color(0xFF171717);
  final Color _selectedDayColor = Color(0xFF303030);

  bool _isLoading = true;
  final WeatherService _weatherService = WeatherService();
  List<dynamic> _forecastDays = [];

  SensorData? _latestSensorData;
  Timer? _sensorTimer;

  // Track if notification has been sent to prevent duplicate alerts
  bool _dangerNotificationSent = false;
  bool _alertNotificationSent = false;
  bool _warningNotificationSent = false;
  bool _criticalNotificationSent = false;

  @override
  void initState() {
    super.initState();
    _generateRealtimeDays();
    _fetchWeatherData();
    _fetchSensorData();
    _sensorTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchSensorData(),
    );
  }

  void _generateRealtimeDays() {
    // Format hari dalam bahasa Indonesia
    final List<String> hariIndo = [
       'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final now = DateTime.now();
    // 5 hari ke belakang termasuk hari ini (total 5 hari: -4, -3, -2, -1, 0)
    _days = List.generate(5, (i) {
      final day = now.subtract(Duration(days: 4 - i));
      return hariIndo[day.weekday - 1];
    });
    // Hari default terpilih adalah hari ini (indeks terakhir)
    _selectedDay = _days[4];
    _selectedDayIndex = 4;
  }

  Future<void> _fetchSensorData() async {
    try {
      final data = await ApiService.fetchLatestSensorData();
      if (mounted) {
        setState(() {
          _latestSensorData = data;
          if (_latestSensorData != null) {
            final waterLevel = double.tryParse(_latestSensorData!.payload) ?? 0;
            statusValue = '${_latestSensorData!.payload} cm';
            _updateWaterStatus(waterLevel);
            _checkAndSendNotification(waterLevel);

            final sensorTime = DateFormat(
              'HH:mm:ss',
            ).format(_latestSensorData!.timestamp);
            lastUpdateText = 'Last Update: $sensorTime • Sensor Online';
          }
        });
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      // Consider updating the UI to show error state
    }
  }

  void _checkAndSendNotification(double waterLevel) {
    // Critical threshold (< 15cm)
    if (waterLevel < 15 && !_criticalNotificationSent) {
      NotificationService.showNotification(
        id: 0,
        title: 'EVAKUASI SEGERA!',
        body:
            'Air hanya ${waterLevel.round()} cm dari sensor! Segera evakuasi sekarang juga!',
      );
      _criticalNotificationSent = true;
      _dangerNotificationSent = false;
      _alertNotificationSent = false;
      _warningNotificationSent = false;
    }
    // Danger threshold (15-30cm)
    else if (waterLevel >= 15 && waterLevel < 30 && !_dangerNotificationSent) {
      NotificationService.showNotification(
        id: 1,
        title: 'BAHAYA BANJIR!',
        body:
            'Ketinggian air hanya ${waterLevel.round()} cm dari sensor. Segera evakuasi!',
      );
      _criticalNotificationSent = false;
      _dangerNotificationSent = true;
      _alertNotificationSent = false;
      _warningNotificationSent = false;
    }
    // Alert threshold (30-50cm)
    else if (waterLevel >= 30 && waterLevel < 50 && !_alertNotificationSent) {
      NotificationService.showNotification(
        id: 2,
        title: 'Siaga Banjir',
        body:
            'Ketinggian air meningkat, ${waterLevel.round()} cm dari sensor. Persiapkan evakuasi.',
      );
      _criticalNotificationSent = false;
      _dangerNotificationSent = false;
      _alertNotificationSent = true;
      _warningNotificationSent = false;
    }
    // Warning threshold (50-70cm)
    else if (waterLevel >= 50 && waterLevel < 70 && !_warningNotificationSent) {
      NotificationService.showNotification(
        id: 3,
        title: 'Waspada Banjir',
        body:
            'Ketinggian air ${waterLevel.round()} cm dari sensor. Mohon waspada.',
      );
      _criticalNotificationSent = false;
      _dangerNotificationSent = false;
      _alertNotificationSent = false;
      _warningNotificationSent = true;
    }
    // Back to normal
    else if (waterLevel >= 70) {
      _criticalNotificationSent = false;
      _dangerNotificationSent = false;
      _alertNotificationSent = false;
      _warningNotificationSent = false;
    }
  }

  void _updateWaterStatus(double waterLevel) {
    if (waterLevel < 30) {
      statusLevel = 'Bahaya';
      statusColor = Colors.red;
    } else if (waterLevel < 50) {
      statusLevel = 'Siaga';
      statusColor = Colors.orange;
    } else if (waterLevel < 70) {
      statusLevel = 'Waspada';
      statusColor = const Color(0xFFFFCC00);
    } else {
      statusLevel = 'Normal';
      statusColor = Colors.green;
    }
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await _weatherService.getWeatherData('Yogyakarta');
      if (mounted) {
        setState(() {
          final currentTemp = data['current']['temp_c'];
          suhu = '${currentTemp.round()}°';
          final DateTime now = DateTime.now();
          tanggalString = DateFormat('EEEE, d MMMM y', 'id_ID').format(now);
          _forecastDays = data['forecast']['forecastday'];
          _updateDayData(_selectedDayIndex);
          final currentPrecip = data['current']['precip_mm'];
          if (currentPrecip > 0) {
            final estimatedChange = (currentPrecip * 1.5).round();
            trenValue = '+$estimatedChange cm';
            if (currentPrecip > 10) {
              prediksiText = 'Naik Cepat';
            } else if (currentPrecip > 5) {
              prediksiText = 'Naik';
            } else if (currentPrecip > 1) {
              prediksiText = 'Naik Lambat';
            } else {
              prediksiText = 'Stabil';
            }
          } else {
            trenValue = '0 cm';
            prediksiText = 'Stabil';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          lastUpdateText = 'Error: Failed to load weather data';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading weather data: $e')),
        );
      }
    }
  }

  void _updateDayData(int dayIndex) {
    if (_forecastDays.isNotEmpty && dayIndex < _forecastDays.length) {
      final forecast = _forecastDays[dayIndex];
      final rainMm = forecast['day']['totalprecip_mm'];
      curahHujan = '${rainMm.toString()} mm/hari';
      Logger().i('${rainMm.toString()} mm/hari');
      Logger().i(rainMm);
      final humidity = forecast['day']['avghumidity'];
      if (rainMm > 25) {
        alertLevelValue = 'Bahaya';
      } else if (rainMm > 15) {
        alertLevelValue = 'Siaga';
      } else if (rainMm > 5) {
        alertLevelValue = 'Waspada';
      } else {
        alertLevelValue = 'Normal';
      }
      if (dayIndex == 0) {
        final currentPrecip = _forecastDays[0]['day']['totalprecip_mm'];
        final estimatedChange = (currentPrecip * 0.5).round();
        trenValue = '+$estimatedChange cm';
        if (currentPrecip > 10) {
          prediksiText = 'Naik';
        } else if (humidity > 85) {
          prediksiText = 'Lembab';
        } else {
          prediksiText = 'Stabil';
        }
      } else {
        final prevDayRain =
            _forecastDays[dayIndex - 1]['day']['totalprecip_mm'];
        final todayRain = rainMm;
        final difference = todayRain - prevDayRain;
        if (difference > 0) {
          trenValue = '+${(difference * 0.5).round()} cm';
          prediksiText = 'Kemungkinan Naik';
        } else if (difference < 0) {
          trenValue = '${(difference * 0.5).round()} cm';
          prediksiText = 'Kemungkinan Turun';
        } else {
          trenValue = '0 cm';
          prediksiText = 'Relatif Stabil';
        }
      }
    }
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(
                    lokasi: lokasi,
                    tanggalString: tanggalString,
                    suhu: suhu,
                  ),
                  const SizedBox(height: 24),
                  DayNavigation(
                    days: _days,
                    selectedDay: _selectedDay,
                    selectedDayColor: _selectedDayColor,
                    cardBackgroundColor: _cardBackgroundColor,
                    onDaySelected: (day) {
                      final index = _days.indexOf(day);
                      setState(() {
                        _selectedDay = day;
                        _selectedDayIndex = index;
                        _updateDayData(index);
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  StatusDashboardCard(
                    statusValue: statusValue,
                    statusLevel: statusLevel,
                    statusColor: statusColor,
                    curahHujan: curahHujan,
                    trenValue: trenValue,
                    prediksiText: prediksiText,
                    alertLevelValue: alertLevelValue,
                  ),
                  const SizedBox(height: 32),
                  FooterSection(lastUpdateText: lastUpdateText),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

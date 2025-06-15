import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class ApiService {
  static const String baseUrl =
      'https://electric-piglet-apparently.ngrok-free.app/api/mqtt/messages';

  static Future<SensorData?> fetchLatestSensorData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isEmpty) return null;

      final sensorDataList =
          jsonData.map((e) => SensorData.fromJson(e)).toList();
      sensorDataList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return sensorDataList.first;
    } else {
      throw Exception("Failed to load data");
    }
  }
}

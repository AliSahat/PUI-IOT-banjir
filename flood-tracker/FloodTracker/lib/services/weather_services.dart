import 'dart:convert';
import 'package:deteksi_banjir/utils/logger_services.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'fbfd2c50fdb24fbd8a6101641252405';
  static const String baseUrl = 'http://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> getWeatherData(String location) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/forecast.json?key=$apiKey&q=$location&days=7&aqi=no&alerts=no',
        ),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        LoggerService.error(
          'Failed to load weather data: ${response.statusCode} - ${response.reasonPhrase}',
        );
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error fetching weather data: $e');
      throw Exception('Error fetching weather data: $e');
    }
  }
}

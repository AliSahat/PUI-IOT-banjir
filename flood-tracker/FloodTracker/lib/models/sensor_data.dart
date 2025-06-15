class SensorData {
  final String topic;
  final String payload;
  final DateTime timestamp;

  SensorData({
    required this.topic,
    required this.payload,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      topic: json['topic'],
      payload: json['payload'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

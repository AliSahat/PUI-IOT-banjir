import 'package:deteksi_banjir/widgets/info_card.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  final String statusValue;
  final String statusLevel;
  final Color statusColor;
  final String curahHujan;
  final String trenValue;
  final String prediksiText;
  final String alertLevelValue;

  const StatusPage({
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Main status value
          Text(
            statusValue,
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusLevel,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 32),

          // Info cards dalam grid
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                InfoCard(
                  title: 'Curah Hujan',
                  value: curahHujan,
                  icon: Icons.water_drop,
                  iconColor: Colors.lightBlueAccent,
                  backgroundColor: Colors.black12,
                ),
                InfoCard(
                  title: 'Tren',
                  value: trenValue,
                  icon: Icons.arrow_upward,
                  iconColor: Colors.lightBlueAccent,
                  backgroundColor: Colors.black12,
                ),
                InfoCard(
                  title: 'Kondisi',
                  value: prediksiText,
                  icon: Icons.cloud,
                  iconColor: Colors.white,
                  backgroundColor: Colors.black12,
                ),
                InfoCard(
                  title: 'Weather',
                  value: alertLevelValue,
                  icon: Icons.thermostat,
                  iconColor: Colors.orangeAccent,
                  backgroundColor: Colors.black12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

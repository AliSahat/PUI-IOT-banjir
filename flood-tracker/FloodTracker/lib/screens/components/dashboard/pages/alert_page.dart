import 'package:flutter/material.dart';
import 'package:deteksi_banjir/widgets/alert_info_card.dart';

class AlertPage extends StatelessWidget {
  final String statusLevel;
  final Color statusColor;

  const AlertPage({
    super.key,
    required this.statusLevel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Warning icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Status: $statusLevel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pantau Terus Kondisi',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          const AlertInfoCard(
            title: 'Batas Alert Berikutnya',
            value: '70 cm (12 cm lagi)',
          ),
          const SizedBox(height: 12),
          const AlertInfoCard(
            title: 'Estimasi Waktu',
            value: '~2-3 jam jika hujan berlanjut',
          ),
          const SizedBox(height: 12),
          const AlertInfoCard(
            title: 'Rekomendasi',
            value: 'Siapkan rencana evakuasi',
          ),
        ],
      ),
    );
  }
}

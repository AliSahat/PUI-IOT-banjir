// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String lokasi;
  final String tanggalString;
  final String suhu;

  const HeaderSection({
    super.key,
    required this.lokasi,
    required this.tanggalString,
    required this.suhu,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lokasi,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tanggalString,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Text(
                suhu,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.water_drop_outlined,
                color: Colors.lightBlueAccent,
                size: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color backgroundColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.backgroundColor = Colors.black12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? Colors.white, size: 18),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

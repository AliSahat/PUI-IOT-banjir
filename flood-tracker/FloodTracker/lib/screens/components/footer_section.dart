import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  final String lastUpdateText;

  const FooterSection({super.key, required this.lastUpdateText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        lastUpdateText,
        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}

// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';

class SimpleHeader extends StatelessWidget {
  const SimpleHeader({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      decoration: const BoxDecoration(
        color: darkGreen,
        border: Border(bottom: BorderSide(color: gold, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFFD7E8DE))),
          const SizedBox(height: 3),
          Text(title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

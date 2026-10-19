// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.value, {super.key});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}

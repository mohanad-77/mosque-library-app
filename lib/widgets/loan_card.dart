// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/models/library_loan.dart';
import 'package:mosque_library_app/widgets/green_button.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({super.key, required this.loan, required this.book, this.action});
  final LibraryLoan loan;
  final LibraryBook book;
  final VoidCallback? action;

  String dateText(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: softBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${loan.memberName} · ${loan.memberId}',
              style: const TextStyle(fontSize: 13, color: muted)),
          Text('النسخة: ${loan.barcode}',
              style: const TextStyle(fontSize: 12, color: muted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: Text('الإرجاع: ${dateText(loan.dueAt)}', style: const TextStyle(fontSize: 13))),
              if (loan.isOverdue)
                const Text('متأخرة',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
            ],
          ),
          if (action != null) ...[
            const SizedBox(height: 12),
            GreenButton(label: 'تسجيل الإرجاع', outline: true, onPressed: action),
          ],
        ],
      ),
    );
  }
}

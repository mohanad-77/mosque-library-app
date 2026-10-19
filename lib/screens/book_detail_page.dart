// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/core/utils/show_note.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/widgets/book_cover.dart';
import 'package:mosque_library_app/widgets/green_button.dart';
import 'package:mosque_library_app/widgets/info_row.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.book});
  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: darkGreen,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('رجوع'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  BookCover(book: book, large: true),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(book.author, style: const TextStyle(fontSize: 14, color: muted)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: softBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          InfoRow(label: 'الفئة', value: book.category),
                          const Divider(color: softBorder, height: 1),
                          InfoRow(
                            label: 'النسخ الورقية',
                            value: book.hasPaper
                                ? '${book.availableCopies} من ${book.totalCopies} متاحة (رف ${book.shelf})'
                                : 'لا توجد نسخ ورقية',
                          ),
                          const Divider(color: softBorder, height: 1),
                          InfoRow(
                            label: 'النسخة الإلكترونية',
                            value: book.hasPdf ? 'PDF · ${book.pdfSize}' : 'غير متوفرة',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'لاستعارة النسخة الورقية، اطلبها من أمين المكتبة لتسجيل الإعارة.',
                      style: TextStyle(fontSize: 13, color: muted),
                    ),
                    const SizedBox(height: 18),
                    GreenButton(
                      label: 'تنزيل الكتاب الإلكتروني',
                      onPressed: book.hasPdf
                          ? () => showNote(context, 'التنزيل تجريبي وغير مربوط بالخادم بعد')
                          : null,
                    ),
                    const SizedBox(height: 10),
                    GreenButton(
                      label: 'عرض موقع النسخة الورقية',
                      outline: true,
                      onPressed: book.hasPaper
                          ? () => showDialog<void>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('موقع النسخة الورقية'),
                                  content: Text('مسجد الرحمة — الرف ${book.shelf}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('إغلاق'),
                                    ),
                                  ],
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

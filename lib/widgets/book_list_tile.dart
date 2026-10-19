// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/widgets/book_cover.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({super.key, required this.book, required this.onTap});
  final LibraryBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = book.availableCopies > 0
        ? 'متاح ورقيًا'
        : book.hasPdf
            ? 'PDF · إلكتروني'
            : 'معار حاليًا';
    final labelColor = book.availableCopies > 0
        ? darkGreen
        : book.hasPdf
            ? const Color(0xFF1E3A8A)
            : const Color(0xFF6B4E00);
    final labelBg = book.availableCopies > 0
        ? softGreen
        : book.hasPdf
            ? const Color(0xFFDBEAFE)
            : const Color(0xFFFFF3CD);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: softBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              BookCover(book: book),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(book.author,
                        style: const TextStyle(fontSize: 12.5, color: muted)),
                    const SizedBox(height: 6),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: labelBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Text(label,
                            style: TextStyle(fontSize: 11.5, color: labelColor)),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: muted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

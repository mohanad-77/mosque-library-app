// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/models/library_book.dart';

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book, this.large = false});
  final LibraryBook book;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: large ? 110 : 52,
      height: large ? 154 : 72,
      decoration: BoxDecoration(
        color: book.coverColor,
        borderRadius: BorderRadius.circular(large ? 8 : 6),
        border: Border(bottom: BorderSide(color: gold, width: large ? 8 : 5)),
      ),
      child: Icon(Icons.menu_book_rounded,
          color: Colors.white.withOpacity(0.42), size: large ? 46 : 22),
    );
  }
}

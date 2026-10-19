// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';

class LibraryBook {
  LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.coverColor,
    required this.totalCopies,
    required this.availableCopies,
    required this.shelf,
    required this.pdfSize,
  });

  final String id;
  final String title;
  final String author;
  final String category;
  final Color coverColor;
  final int totalCopies;
  int availableCopies;
  final String shelf;
  final String? pdfSize;

  bool get hasPaper => totalCopies > 0;
  bool get hasPdf => pdfSize != null;
}

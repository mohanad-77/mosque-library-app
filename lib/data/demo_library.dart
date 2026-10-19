// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/models/library_loan.dart';

class DemoLibrary extends ChangeNotifier {
  // بيانات تجريبية من التصور، وليست محتوى قاعدة البيانات الحقيقية.
  final List<LibraryBook> books = [
    LibraryBook(
      id: 'b1',
      title: 'رياض الصالحين',
      author: 'الإمام النووي',
      category: 'الحديث',
      coverColor: const Color(0xFF1B8A5A),
      totalCopies: 3,
      availableCopies: 2,
      shelf: 'أ-3',
      barcodes: ['MSQ1-001', 'MSQ1-002', 'MSQ1-003'],
      pdfSize: '12 MB',
    ),
    LibraryBook(
      id: 'b2',
      title: 'الأربعون النووية',
      author: 'الإمام النووي',
      category: 'الحديث',
      coverColor: const Color(0xFF2F6DB5),
      totalCopies: 0,
      availableCopies: 0,
      shelf: '—',
      barcodes: const [],
      pdfSize: '3 MB',
    ),
    LibraryBook(
      id: 'b3',
      title: 'تفسير ابن كثير',
      author: 'ابن كثير',
      category: 'التفسير',
      coverColor: const Color(0xFF7A5A2C),
      totalCopies: 1,
      availableCopies: 0,
      shelf: 'ب-1',
      barcodes: ['MSQ1-004'],
      pdfSize: null,
    ),
    LibraryBook(
      id: 'b4',
      title: 'الرحيق المختار',
      author: 'صفي الرحمن المباركفوري',
      category: 'السيرة',
      coverColor: darkGreen,
      totalCopies: 2,
      availableCopies: 2,
      shelf: 'ج-2',
      barcodes: ['MSQ1-006', 'MSQ1-007'],
      pdfSize: null,
    ),
  ];

  final List<LibraryLoan> loans = [
    LibraryLoan(
      bookId: 'b1',
      barcode: 'MSQ1-003',
      memberId: 'T-2030',
      memberName: 'خالد محمد',
      borrowedAt: DateTime.now().subtract(const Duration(days: 5)),
      dueAt: DateTime.now().add(const Duration(days: 9)),
    ),
    LibraryLoan(
      bookId: 'b3',
      barcode: 'MSQ1-004',
      memberId: 'T-2040',
      memberName: 'محمد علي',
      borrowedAt: DateTime.now().subtract(const Duration(days: 20)),
      dueAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  static const members = {
    'T-1025': 'سعد العتيبي',
    'T-2030': 'خالد محمد',
    'T-2040': 'محمد علي',
  };

  LibraryBook? findByBarcode(String raw) {
    final barcode = raw.trim().toUpperCase();
    for (final book in books) {
      if (book.barcodes.contains(barcode)) return book;
    }
    return null;
  }

  LibraryBook bookById(String id) => books.firstWhere((b) => b.id == id);

  bool barcodeAvailable(String barcode) {
    final book = findByBarcode(barcode);
    if (book == null || book.availableCopies == 0) return false;
    return !loans.any((l) => l.isActive && l.barcode == barcode.trim().toUpperCase());
  }

  String? lend({required String barcode, required String memberId}) {
    final normalized = barcode.trim().toUpperCase();
    final normalizedMember = memberId.trim().toUpperCase();
    final book = findByBarcode(normalized);
    if (book == null) return 'الباركود غير موجود في المكتبة';
    if (!barcodeAvailable(normalized)) return 'هذه النسخة غير متاحة للإعارة';
    final memberName = members[normalizedMember];
    if (memberName == null) return 'رقم المستفيد غير مسجل في النموذج التجريبي';
    final today = DateTime.now();
    loans.insert(
      0,
      LibraryLoan(
        bookId: book.id,
        barcode: normalized,
        memberId: normalizedMember,
        memberName: memberName,
        borrowedAt: today,
        dueAt: today.add(const Duration(days: 14)),
      ),
    );
    book.availableCopies--;
    notifyListeners();
    return null;
  }

  void returnCopy(LibraryLoan loan) {
    if (!loan.isActive) return;
    loan.returnedAt = DateTime.now();
    final book = bookById(loan.bookId);
    if (book.availableCopies < book.totalCopies) book.availableCopies++;
    notifyListeners();
  }
}

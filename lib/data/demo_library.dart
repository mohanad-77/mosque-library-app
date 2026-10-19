// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/models/library_loan.dart';

class DemoLibrary extends ChangeNotifier {
  // بيانات تجريبية، وليست محتوى قاعدة البيانات الحقيقية.
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
      pdfSize: null,
    ),
  ];

  final List<LibraryLoan> loans = [
    LibraryLoan(
      bookId: 'b1',
      memberId: 'T-2030',
      memberName: 'خالد محمد',
      borrowedAt: DateTime.now().subtract(const Duration(days: 5)),
      dueAt: DateTime.now().add(const Duration(days: 9)),
    ),
    LibraryLoan(
      bookId: 'b3',
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

  LibraryBook bookById(String id) => books.firstWhere((b) => b.id == id);

  // تختار الشاشة الكتاب باسمه؛ ويُحفظ المعرّف داخليًا لمنع الخلط
  // بين كتابين يحملان العنوان نفسه.
  String? lend({required String bookId, required String memberId}) {
    LibraryBook? book;
    for (final candidate in books) {
      if (candidate.id == bookId) {
        book = candidate;
        break;
      }
    }
    if (book == null) return 'اختر كتابًا صحيحًا من القائمة';
    if (!book.hasPaper || book.availableCopies <= 0) {
      return 'لا توجد نسخ ورقية متاحة لهذا الكتاب';
    }
    final normalizedMember = memberId.trim().toUpperCase();
    final memberName = members[normalizedMember];
    if (memberName == null) return 'رقم المستفيد غير مسجل في النموذج التجريبي';

    final today = DateTime.now();
    loans.insert(
      0,
      LibraryLoan(
        bookId: book.id,
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

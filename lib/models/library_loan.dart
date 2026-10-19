// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.

class LibraryLoan {
  LibraryLoan({
    required this.bookId,
    required this.memberId,
    required this.memberName,
    required this.borrowedAt,
    required this.dueAt,
    this.returnedAt,
  });

  final String bookId;
  final String memberId;
  final String memberName;
  final DateTime borrowedAt;
  final DateTime dueAt;
  DateTime? returnedAt;

  bool get isActive => returnedAt == null;
  bool get isOverdue => isActive && dueAt.isBefore(DateTime.now());
}

// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/core/utils/show_note.dart';
import 'package:mosque_library_app/data/demo_library.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/models/library_loan.dart';
import 'package:mosque_library_app/screens/book_detail_page.dart';
import 'package:mosque_library_app/widgets/book_list_tile.dart';
import 'package:mosque_library_app/widgets/bottom_tabs.dart';
import 'package:mosque_library_app/widgets/field_label.dart';
import 'package:mosque_library_app/widgets/green_button.dart';
import 'package:mosque_library_app/widgets/loan_card.dart';
import 'package:mosque_library_app/widgets/simple_header.dart';

class LibrarianPage extends StatefulWidget {
  const LibrarianPage({super.key, required this.library, required this.onLogout});
  final DemoLibrary library;
  final VoidCallback onLogout;

  @override
  State<LibrarianPage> createState() => _LibrarianPageState();
}

class _LibrarianPageState extends State<LibrarianPage> {
  final bookSearchController = TextEditingController();
  final memberController = TextEditingController(text: 'T-1025');
  String? selectedBookId;
  int tab = 0;

  @override
  void dispose() {
    bookSearchController.dispose();
    memberController.dispose();
    super.dispose();
  }

  LibraryBook? get selectedBook {
    final id = selectedBookId;
    if (id == null) return null;
    for (final book in widget.library.books) {
      if (book.id == id) return book;
    }
    return null;
  }

  List<LibraryBook> get matchingBooks {
    final query = bookSearchController.text.trim().toLowerCase();
    return widget.library.books.where((book) {
      return book.hasPaper &&
          (query.isEmpty ||
              book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query));
    }).toList();
  }

  void selectBook(LibraryBook book) {
    setState(() {
      selectedBookId = book.id;
      bookSearchController.text = book.title;
    });
  }

  void confirmLoan() {
    final book = selectedBook;
    if (book == null) {
      showNote(context, 'اختر كتابًا من نتائج البحث أولًا');
      return;
    }
    final error = widget.library.lend(
      bookId: book.id,
      memberId: memberController.text,
    );
    if (error != null) {
      showNote(context, error);
      return;
    }
    setState(() {
      selectedBookId = null;
      bookSearchController.clear();
    });
    showNote(context, 'تمت إعارة كتاب «${book.title}» بنجاح (تجريبيًا)');
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['تسجيل إعارة', 'إرجاع الكتب', 'المتأخرات', 'كتب المكتبة'];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SimpleHeader(title: titles[tab], subtitle: 'أمين المكتبة · مسجد الرحمة'),
            Expanded(
              child: tab == 0
                  ? loanForm()
                  : tab == 1
                      ? returnsList()
                      : tab == 2
                          ? overdueList()
                          : libraryBooks(),
            ),
            BottomTabs(
              labels: const ['إعارة', 'إرجاع', 'المتأخرات', 'الكتب'],
              icons: const [
                Icons.add_circle_outline,
                Icons.assignment_return_outlined,
                Icons.warning_amber_outlined,
                Icons.menu_book_outlined,
              ],
              current: tab,
              onChanged: (index) => setState(() => tab = index),
            ),
          ],
        ),
      ),
    );
  }

  Widget loanForm() {
    final book = selectedBook;
    final available = book != null && book.availableCopies > 0;
    final memberName =
        DemoLibrary.members[memberController.text.trim().toUpperCase()];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('1. اختيار الكتاب باسمه'),
          TextField(
            controller: bookSearchController,
            onChanged: (_) => setState(() => selectedBookId = null),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: muted),
              hintText: 'ابحث باسم الكتاب أو المؤلف',
            ),
          ),
          const SizedBox(height: 10),
          if (book == null) ...[
            const Text('اختر كتابًا من نتائج البحث:',
                style: TextStyle(color: muted, fontSize: 12)),
            const SizedBox(height: 6),
            if (matchingBooks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('لا توجد كتب ورقية تطابق البحث'),
              )
            else
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: softBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (final result in matchingBooks)
                      ListTile(
                        title: Text(result.title),
                        subtitle: Text(
                          '${result.author} · المتاح ${result.availableCopies} من ${result.totalCopies}',
                          style: const TextStyle(fontSize: 12, color: muted),
                        ),
                        trailing: Icon(
                          result.availableCopies > 0
                              ? Icons.check_circle_outline
                              : Icons.block,
                          color: result.availableCopies > 0
                              ? darkGreen
                              : const Color(0xFFB45309),
                        ),
                        onTap: () => selectBook(result),
                      ),
                  ],
                ),
              ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F7F3),
                border: Border.all(color: const Color(0xFFCFE3D7)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('المؤلف: ${book.author} · الرف: ${book.shelf}',
                      style: const TextStyle(color: muted, fontSize: 12.5)),
                  const SizedBox(height: 4),
                  Text(
                    available
                        ? 'النسخ المتاحة للإعارة: ${book.availableCopies}'
                        : 'لا توجد نسخ ورقية متاحة حاليًا',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: available ? darkGreen : const Color(0xFFB45309),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => setState(() {
                        selectedBookId = null;
                        bookSearchController.clear();
                      }),
                      child: const Text('تغيير الكتاب'),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          const FieldLabel('2. المستفيد'),
          const FieldLabel('رقم المستفيد'),
          TextField(
            controller: memberController,
            textDirection: TextDirection.ltr,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'T-1025'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(memberName ?? 'رقم المستفيد غير مسجل',
                    style: const TextStyle(fontSize: 13, color: muted)),
              ),
              const Text('الإرجاع بعد 14 يومًا', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 18),
          GreenButton(
            label: 'تأكيد إعارة الكتاب',
            onPressed: available && memberName != null ? confirmLoan : null,
          ),
          const SizedBox(height: 12),
          const Text(
            'للتجربة: اختر «رياض الصالحين» ثم أدخل رقم المستفيد T-1025. التغييرات مؤقتة.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget returnsList() {
    final active = widget.library.loans.where((l) => l.isActive).toList();
    if (active.isEmpty) return const Center(child: Text('لا توجد إعارات نشطة'));
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: active.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final loan = active[i];
        return LoanCard(
          loan: loan,
          book: widget.library.bookById(loan.bookId),
          action: () => confirmReturn(loan),
        );
      },
    );
  }

  Widget overdueList() {
    final overdue = widget.library.loans.where((l) => l.isOverdue).toList();
    if (overdue.isEmpty) return const Center(child: Text('لا توجد إعارات متأخرة'));
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: overdue.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final loan = overdue[i];
        return LoanCard(loan: loan, book: widget.library.bookById(loan.bookId));
      },
    );
  }

  Widget libraryBooks() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final book in widget.library.books) ...[
          BookListTile(
            book: book,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        GreenButton(label: 'تسجيل الخروج', outline: true, onPressed: widget.onLogout),
      ],
    );
  }

  Future<void> confirmReturn(LibraryLoan loan) async {
    final book = widget.library.bookById(loan.bookId);
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الإرجاع'),
        content: Text('هل تم استلام كتاب «${book.title}» من ${loan.memberName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
    if (!mounted || approved != true) return;
    widget.library.returnCopy(loan);
    showNote(context, 'تم إرجاع كتاب «${book.title}» بنجاح (تجريبيًا)');
  }
}

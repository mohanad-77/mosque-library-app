// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/core/utils/show_note.dart';
import 'package:mosque_library_app/data/demo_library.dart';
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
  final barcodeController = TextEditingController(text: 'MSQ1-001');
  final memberController = TextEditingController(text: 'T-1025');
  int tab = 0;

  @override
  void dispose() {
    barcodeController.dispose();
    memberController.dispose();
    super.dispose();
  }

  void confirmLoan() {
    final error = widget.library.lend(
      barcode: barcodeController.text,
      memberId: memberController.text,
    );
    if (error != null) {
      showNote(context, error);
      return;
    }
    showNote(context, 'تم تسجيل الإعارة بنجاح (داخل النموذج التجريبي)');
    barcodeController.clear();
    setState(() {});
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
    final barcode = barcodeController.text.trim().toUpperCase();
    final book = widget.library.findByBarcode(barcode);
    final available = book != null && widget.library.barcodeAvailable(barcode);
    final memberName = DemoLibrary.members[memberController.text.trim().toUpperCase()];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('1. امسح باركود النسخة'),
          Container(
            height: 130,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: ink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner_rounded, size: 66, color: gold),
                SizedBox(height: 5),
                Text('محاكاة الباركود — بدون كاميرا',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const FieldLabel('رمز النسخة (أدخله يدويًا)'),
          TextField(
            controller: barcodeController,
            textDirection: TextDirection.ltr,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'MSQ1-001'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F7F3),
              border: Border.all(color: const Color(0xFFCFE3D7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book?.title ?? 'لم يتم العثور على النسخة',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(
                        book == null ? 'أدخل باركودًا صحيحًا' : 'النسخة $barcode · رف ${book.shelf}',
                        style: const TextStyle(color: muted, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: available ? darkGreen : const Color(0xFFB45309),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(available ? 'متاحة' : 'غير متاحة',
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
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
              const Text('تاريخ الإرجاع: بعد 14 يومًا', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 18),
          GreenButton(
            label: 'تأكيد الإعارة',
            onPressed: available && memberName != null ? confirmLoan : null,
          ),
          const SizedBox(height: 12),
          const Text(
            'جرّب الباركود MSQ1-001 مع المستفيد T-1025. كل التغييرات مؤقتة.',
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
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الإرجاع'),
        content: Text('هل تم استلام النسخة ${loan.barcode} من ${loan.memberName}؟'),
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
    showNote(context, 'تم إرجاع النسخة بنجاح (داخل النموذج التجريبي)');
  }
}

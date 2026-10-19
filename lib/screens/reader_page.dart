// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/data/demo_library.dart';
import 'package:mosque_library_app/models/book_filter.dart';
import 'package:mosque_library_app/models/library_book.dart';
import 'package:mosque_library_app/screens/book_detail_page.dart';
import 'package:mosque_library_app/widgets/book_list_tile.dart';
import 'package:mosque_library_app/widgets/bottom_tabs.dart';
import 'package:mosque_library_app/widgets/green_button.dart';
import 'package:mosque_library_app/widgets/simple_header.dart';
import 'package:mosque_library_app/widgets/loan_card.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.library, required this.onLogout});
  final DemoLibrary library;
  final VoidCallback onLogout;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final searchController = TextEditingController();
  BookFilter filter = BookFilter.all;
  int tab = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<LibraryBook> get visibleBooks {
    final search = searchController.text.trim().toLowerCase();
    return widget.library.books.where((book) {
      if (filter == BookFilter.paper && !book.hasPaper) return false;
      if (filter == BookFilter.electronic && !book.hasPdf) return false;
      return book.title.toLowerCase().contains(search) ||
          book.author.toLowerCase().contains(search);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (tab == 0) ...[
              Container(
                width: double.infinity,
                color: darkGreen,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('السلام عليكم',
                        style: TextStyle(fontSize: 13, color: Color(0xFFD7E8DE))),
                    const SizedBox(height: 2),
                    const Text('أحمد، مسجد الرحمة',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: muted),
                        hintText: 'ابحث بالعنوان أو المؤلف',
                        hintStyle: const TextStyle(fontSize: 14, color: muted),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                child: Row(
                  children: [
                    filterChip('الكل', BookFilter.all),
                    const SizedBox(width: 8),
                    filterChip('ورقي', BookFilter.paper),
                    const SizedBox(width: 8),
                    filterChip('إلكتروني', BookFilter.electronic),
                  ],
                ),
              ),
              Expanded(
                child: visibleBooks.isEmpty
                    ? const Center(child: Text('لا توجد كتب تطابق البحث'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                        itemCount: visibleBooks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final book = visibleBooks[index];
                          return BookListTile(
                            book: book,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookDetailPage(book: book),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ] else if (tab == 1)
              Expanded(child: readerLoans())
            else
              Expanded(child: accountPage()),
            BottomTabs(
              labels: const ['المكتبة', 'إعاراتي', 'حسابي'],
              icons: const [Icons.menu_book_outlined, Icons.receipt_long_outlined, Icons.person_outline],
              current: tab,
              onChanged: (index) => setState(() => tab = index),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterChip(String label, BookFilter value) {
    final selected = filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => filter = value),
      selectedColor: darkGreen,
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      side: BorderSide(color: selected ? darkGreen : const Color(0xFFD1D5DB)),
      labelStyle: TextStyle(fontSize: 13, color: selected ? Colors.white : ink),
      shape: const StadiumBorder(),
      showCheckmark: false,
    );
  }

  Widget readerLoans() {
    final loans = widget.library.loans.where((l) => l.memberId == 'T-1025' && l.isActive).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SimpleHeader(title: 'إعاراتي', subtitle: 'سعد العتيبي · T-1025'),
        Expanded(
          child: loans.isEmpty
              ? const Center(child: Text('لا توجد إعارات مسجلة لهذا المستفيد'))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: loans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final loan = loans[index];
                    return LoanCard(loan: loan, book: widget.library.bookById(loan.bookId));
                  },
                ),
        ),
      ],
    );
  }

  Widget accountPage() {
    return Column(
      children: [
        const SimpleHeader(title: 'حسابي', subtitle: 'مستفيد · مسجد الرحمة'),
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 34,
          backgroundColor: softGreen,
          child: Icon(Icons.person, color: darkGreen, size: 34),
        ),
        const SizedBox(height: 12),
        const Text('سعد العتيبي', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        const Text('رقم المستفيد: T-1025', style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GreenButton(label: 'تسجيل الخروج', onPressed: widget.onLogout, outline: true),
        ),
      ],
    );
  }
}

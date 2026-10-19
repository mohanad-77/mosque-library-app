// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/data/demo_library.dart';
import 'package:mosque_library_app/models/app_role.dart';
import 'package:mosque_library_app/screens/login_page.dart';
import 'package:mosque_library_app/screens/librarian_page.dart';
import 'package:mosque_library_app/screens/reader_page.dart';

class MosqueLibraryApp extends StatefulWidget {
  const MosqueLibraryApp({super.key});

  @override
  State<MosqueLibraryApp> createState() => _MosqueLibraryAppState();
}

class _MosqueLibraryAppState extends State<MosqueLibraryApp> {
  final DemoLibrary library = DemoLibrary();
  AppRole? role;

  @override
  void dispose() {
    library.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مكتبات المساجد',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: darkGreen),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: ink),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: darkGreen, width: 1.5),
          ),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: AnimatedBuilder(
        animation: library,
        builder: (context, _) {
          if (role == null) {
            return LoginPage(onLogin: (selected) => setState(() => role = selected));
          }
          if (role == AppRole.librarian) {
            return LibrarianPage(
              library: library,
              onLogout: () => setState(() => role = null),
            );
          }
          return ReaderPage(
            library: library,
            onLogout: () => setState(() => role = null),
          );
        },
      ),
    );
  }
}

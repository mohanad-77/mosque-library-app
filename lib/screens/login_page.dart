// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';
import 'package:mosque_library_app/core/utils/show_note.dart';
import 'package:mosque_library_app/models/app_role.dart';
import 'package:mosque_library_app/widgets/green_button.dart';
import 'package:mosque_library_app/widgets/field_label.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});
  final ValueChanged<AppRole> onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: 'ahmad@mosque.local');
  final passwordController = TextEditingController();
  AppRole selectedRole = AppRole.reader;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    if (!emailController.text.contains('@') || passwordController.text.trim().isEmpty) {
      showNote(context, 'أدخل البريد الإلكتروني وكلمة المرور للتجربة');
      return;
    }
    // هذه واجهة دخول تجريبية فقط، ولا تتحقق من هوية المستخدم.
    widget.onLogin(selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 52, 28, 40),
              decoration: const BoxDecoration(
                color: darkGreen,
                border: Border(bottom: BorderSide(color: gold, width: 6)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(color: gold, shape: BoxShape.circle),
                    child: const Icon(Icons.menu_book_rounded, size: 36, color: darkGreen),
                  ),
                  const SizedBox(height: 14),
                  const Text('مكتبات المساجد',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('سجّل دخولك للوصول إلى مكتبة مسجدك',
                      style: TextStyle(color: Color(0xFFD7E8DE), fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('البريد الإلكتروني'),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(hintText: 'example@mosque.local'),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('كلمة المرور'),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      onSubmitted: (_) => submit(),
                      decoration: const InputDecoration(hintText: 'أدخل كلمة المرور'),
                    ),
                    const SizedBox(height: 18),
                    const Text('نوع الحساب (للتجربة فقط)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const SizedBox(
                              width: double.infinity,
                              child: Text('مستفيد', textAlign: TextAlign.center),
                            ),
                            selected: selectedRole == AppRole.reader,
                            onSelected: (_) => setState(() => selectedRole = AppRole.reader),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ChoiceChip(
                            label: const SizedBox(
                              width: double.infinity,
                              child: Text('أمين المكتبة', textAlign: TextAlign.center),
                            ),
                            selected: selectedRole == AppRole.librarian,
                            onSelected: (_) => setState(() => selectedRole = AppRole.librarian),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GreenButton(label: 'دخول', onPressed: submit),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text('نسيت كلمة المرور؟ تواصل مع المشرف',
                          style: TextStyle(color: muted, fontSize: 13)),
                    ),
                    const SizedBox(height: 14),
                    const Center(
                      child: Text('تجربة واجهات فقط: أي كلمة مرور غير فارغة',
                          style: TextStyle(fontSize: 12, color: muted)),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('الخادم غير متصل · بيانات تجريبية',
                  style: TextStyle(color: muted, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// تطبيق مكتبات المساجد - نموذج تجريبي قابل للتوسعة.
import 'package:flutter/material.dart';
import 'package:mosque_library_app/core/theme/app_colors.dart';

class BottomTabs extends StatelessWidget {
  const BottomTabs({
    super.key,
    required this.labels,
    required this.icons,
    required this.current,
    required this.onChanged,
  });
  final List<String> labels;
  final List<IconData> icons;
  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: softBorder)),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.only(top: 7, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: i == current ? gold : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icons[i], size: 20, color: i == current ? darkGreen : muted),
                      const SizedBox(height: 3),
                      Text(labels[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: i == current ? FontWeight.w700 : FontWeight.w400,
                            color: i == current ? darkGreen : muted,
                          )),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

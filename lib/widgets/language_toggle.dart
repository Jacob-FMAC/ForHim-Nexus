import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../config/theme_config.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isZH = localeProvider.isChinese;

    return GestureDetector(
      onTap: () {
        localeProvider.setLocale(
          isZH ? const Locale('en') : const Locale('zh'),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ThemeConfig.surfaceDark.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ThemeConfig.neonCyan.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CN',
              style: TextStyle(
                color: isZH ? ThemeConfig.neonCyan : Colors.white38,
                fontWeight: isZH ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
            const Text(' / ', style: TextStyle(color: Colors.white10, fontSize: 12)),
            Text(
              'EN',
              style: TextStyle(
                color: !isZH ? ThemeConfig.neonCyan : Colors.white38,
                fontWeight: !isZH ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

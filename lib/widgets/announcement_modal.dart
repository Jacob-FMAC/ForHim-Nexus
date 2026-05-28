import 'package:flutter/material.dart';
import '../config/theme_config.dart';

void showAnnouncementModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ThemeConfig.surfaceDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeConfig.neonCyan.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: ThemeConfig.neonCyan.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '公告 / ANNOUNCEMENT',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.neonCyan,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '欢迎来到 ForHim 电子研究俱乐部！\n\n'
                '本次义卖会活动预约系统现已开放。由于场地限制，请提前预约以获取入场二维码门票。\n\n'
                '注意：请妥善保管您的门票二维码，它是入场的唯一凭证。',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

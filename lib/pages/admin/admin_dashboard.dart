import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/glassmorphism_card.dart';
import '../../config/theme_config.dart';
import '../../l10n/app_strings.dart';
import 'code_validation_page.dart';
import 'crowd_analytics_page.dart';
import 'reservation_list_page.dart';
import 'settings_page.dart';
import 'scan_logs_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final lang = Provider.of<LocaleProvider>(context).locale.languageCode;

    if (!adminProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.get('admin_login', lang))),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: GlassmorphismCard(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_person_rounded, size: 64, color: ThemeConfig.neonCyan),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppStrings.get('password', lang),
                        ),
                      ),
                      const SizedBox(height: 30),
                      NeonButton(
                        text: AppStrings.get('confirm', lang),
                        isLoading: adminProvider.isLoading,
                        onPressed: () async {
                          final success = await adminProvider.login(_passwordController.text);
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid password')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN CONSOLE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => adminProvider.logout(),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildMenuCard(
            context,
            Icons.password_rounded,
            AppStrings.get('scan_qr', lang), // Could change string to 'validate_code' in lang files, but keep it for now or use plain string.
            'Verify codes manually',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CodeValidationPage())),
          ),
          _buildMenuCard(
            context,
            Icons.analytics_rounded,
            AppStrings.get('analytics', lang),
            'Crowd statistics',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CrowdAnalyticsPage())),
          ),
          _buildMenuCard(
            context,
            Icons.people_rounded,
            'RESERVATIONS',
            'Manage bookings',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationListPage())),
          ),
          _buildMenuCard(
            context,
            Icons.settings_suggest_rounded,
            'SETTINGS',
            'System control',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
          _buildMenuCard(
            context,
            Icons.history_rounded,
            'SCAN LOGS',
            'Verification history',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanLogsPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphismCard(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: ThemeConfig.neonCyan),
              const SizedBox(height: 20),
              Text(
                title.toUpperCase(),
                style: const TextStyle(fontFamily: 'Orbitron', fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.white38)),
            ],
          ),
        ),
      ),
    );
  }
}

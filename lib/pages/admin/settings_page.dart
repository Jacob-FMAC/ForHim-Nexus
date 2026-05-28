import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/glassmorphism_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _openTimeController = TextEditingController();
  final _closeTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    await provider.fetchSettings();
    setState(() {
      _openTimeController.text = provider.settings['reservation_open_time'] ?? '';
      _closeTimeController.text = provider.settings['reservation_close_time'] ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    final success = await provider.updateSettings({
      'reservation_open_time': _openTimeController.text,
      'reservation_close_time': _closeTimeController.text,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Settings updated successfully' : 'Failed to update settings')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SYSTEM SETTINGS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RESERVATION CONTROL',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 14,
                letterSpacing: 2,
                color: ThemeConfig.neonCyan,
              ),
            ),
            const SizedBox(height: 24),
            GlassmorphismCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTextField('Open Time (YYYY-MM-DD HH:MM:SS)', _openTimeController),
                    const SizedBox(height: 20),
                    _buildTextField('Close Time (YYYY-MM-DD HH:MM:SS)', _closeTimeController),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Consumer<AdminProvider>(
              builder: (context, provider, _) {
                return NeonButton(
                  text: 'SAVE SETTINGS',
                  isLoading: provider.isLoading,
                  onPressed: _saveSettings,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: const TextStyle(fontFamily: 'Orbitron', fontSize: 14),
        ),
      ],
    );
  }
}

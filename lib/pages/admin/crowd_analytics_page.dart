import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/glassmorphism_card.dart';
import '../../config/theme_config.dart';
import 'dart:async';

class CrowdAnalyticsPage extends StatefulWidget {
  const CrowdAnalyticsPage({super.key});

  @override
  State<CrowdAnalyticsPage> createState() => _CrowdAnalyticsPageState();
}

class _CrowdAnalyticsPageState extends State<CrowdAnalyticsPage> {
  final AdminService _adminService = AdminService();
  Map<String, dynamic>? _analytics;
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await _adminService.getAnalytics();
      setState(() {
        _analytics = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('CROWD ANALYTICS'),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.2),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Colors.redAccent, size: 8),
                  SizedBox(width: 4),
                  Text('LIVE', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildStatCard(),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RECENT VISITORS',
                        style: TextStyle(fontFamily: 'Orbitron', letterSpacing: 2, color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildVisitorList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard() {
    return Column(
      children: [
        GlassmorphismCard(
          showGlow: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Text(
                  'TOTAL ADMITTED',
                  style: TextStyle(fontFamily: 'Orbitron', letterSpacing: 4, color: ThemeConfig.neonCyan),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_analytics?['admitted_count'] ?? 0}',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassmorphismCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'TOTAL RESERVATIONS',
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 10, letterSpacing: 2, color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_analytics?['total_reservations'] ?? 0}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassmorphismCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'PENDING TICKETS',
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 10, letterSpacing: 2, color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_analytics?['pending_count'] ?? 0}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisitorList() {
    final visitors = _analytics?['recent_visitors'] as List? ?? [];
    if (visitors.isEmpty) return const Text('No visitors yet');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visitors.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.white10),
      itemBuilder: (context, index) {
        final v = visitors[index];
        return ListTile(
          leading: const Icon(Icons.account_circle_rounded, color: ThemeConfig.neonCyan),
          title: Text(v['name'] ?? ''),
          subtitle: Text(v['type'] ?? '', style: const TextStyle(color: Colors.white38)),
          trailing: Text(
            () {
              final timeStr = v['time']?.toString().split(' ').last ?? '';
              return timeStr.substring(0, timeStr.length > 5 ? 5 : timeStr.length);
            }(),
            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12),
          ),
        );
      },
    );
  }
}

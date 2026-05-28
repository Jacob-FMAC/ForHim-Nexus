import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/glassmorphism_card.dart';
import '../../config/theme_config.dart';

class ScanLogsPage extends StatefulWidget {
  const ScanLogsPage({super.key});

  @override
  State<ScanLogsPage> createState() => _ScanLogsPageState();
}

class _ScanLogsPageState extends State<ScanLogsPage> {
  final AdminService _adminService = AdminService();
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _adminService.getLogs();
      setState(() {
        _logs = data;
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
        title: const Text('SCAN LOGS'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? const Center(child: Text('NO LOGS FOUND', style: TextStyle(color: Colors.white24)))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return _buildLogCard(log);
                  },
                ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log) {
    final bool isSuccess = (log['result'] ?? '').toString().contains('成功') || (log['result'] ?? '').toString().contains('successful');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismCard(
        child: ListTile(
          leading: Icon(
            isSuccess ? Icons.check_circle_outline_rounded : Icons.highlight_off_rounded,
            color: isSuccess ? Colors.greenAccent : Colors.redAccent,
          ),
          title: Text(
            log['visitor_name'] ?? 'Unknown Visitor',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${log['result']}\n${log['scanner']}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          trailing: Text(
            () {
              final timeStr = log['time']?.toString().split(' ').last ?? '';
              return timeStr.substring(0, timeStr.length > 5 ? 5 : timeStr.length);
            }(),
            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 10, color: Colors.white24),
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/glassmorphism_card.dart';
import '../../config/theme_config.dart';

class CodeValidationPage extends StatefulWidget {
  const CodeValidationPage({super.key});

  @override
  State<CodeValidationPage> createState() => _CodeValidationPageState();
}

class _CodeValidationPageState extends State<CodeValidationPage> {
  final AdminService _adminService = AdminService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _processCode(String code) async {
    if (code.isEmpty || _isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final result = await _adminService.validateTicket(code, 'Admin App');
      _showResult(result);
    } catch (e) {
      _showError(e.toString());
    } finally {
      _controller.clear();
      FocusScope.of(context).requestFocus(_focusNode);
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showResult(Map<String, dynamic> result) {
    final s = result['success'];
    final success = s == true || s == 1;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphismCard(
        borderRadius: 0,
        child: Container(
          padding: const EdgeInsets.all(40),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle_rounded : Icons.error_rounded,
                size: 80,
                color: success ? Colors.greenAccent : Colors.redAccent,
              ),
              const SizedBox(height: 24),
              Text(
                result['message'] ?? (success ? 'Valid Code' : 'Invalid Code'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (result['visitor_name'] != null) ...[
                const SizedBox(height: 16),
                Text(
                  'VISITOR: ${result['visitor_name']}',
                  style: const TextStyle(fontFamily: 'Orbitron', color: Colors.white70),
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(_focusNode);
                },
                child: const Text('CONTINUE'),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() => FocusScope.of(context).requestFocus(_focusNode));
  }

  void _showError(String message) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CODE VALIDATION')),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.password_rounded, size: 80, color: ThemeConfig.neonCyan),
                  const SizedBox(height: 40),
                  const Text('ENTER VERIFICATION CODE', style: TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Orbitron', letterSpacing: 2)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Orbitron', fontSize: 32, letterSpacing: 6, color: ThemeConfig.neonCyan, fontWeight: FontWeight.bold),
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'FH-XXXXX',
                      hintStyle: TextStyle(color: Colors.white10),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (val) {
                      _processCode(val.trim().toUpperCase());
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _processCode(_controller.text.trim().toUpperCase()),
                    child: const Text('VERIFY', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: ThemeConfig.neonCyan),
              ),
            ),
        ],
      ),
    );
  }
}

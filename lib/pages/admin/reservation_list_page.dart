import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/glassmorphism_card.dart';
import '../../config/theme_config.dart';
import '../../utils/privacy_utils.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final AdminService _adminService = AdminService();
  List<dynamic> _reservations = [];
  List<dynamic> _filteredReservations = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isNameMasked = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterReservations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await _adminService.getReservations();
      setState(() {
        _reservations = data;
        _filteredReservations = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterReservations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReservations = _reservations.where((r) {
        final nameCn = (r['name_cn'] ?? '').toString().toLowerCase();
        final nameEn = (r['name_en'] ?? '').toString().toLowerCase();
        final id = (r['id'] ?? '').toString().toLowerCase();
        return nameCn.contains(query) || nameEn.contains(query) || id.contains(query);
      }).toList();
    });
  }

  Future<void> _deleteReservation(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DELETE RESERVATION'),
        content: const Text('ARE YOU SURE YOU WANT TO DELETE THIS RECORD? THIS ACTION CANNOT BE UNDONE.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await _adminService.deleteReservation(id);
        if (result['success'] == true || result['success'] == 1) {
          _loadData();
        } else {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Delete failed')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RESERVATIONS'),
        actions: [
          IconButton(
            icon: Icon(_isNameMasked ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() => _isNameMasked = !_isNameMasked);
            },
          ),
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'SEARCH BY NAME OR ID',
                prefixIcon: const Icon(Icons.search_rounded, color: ThemeConfig.neonCyan),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () => _searchController.clear())
                  : null,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredReservations.isEmpty
                    ? const Center(child: Text('NO RESERVATIONS FOUND', style: TextStyle(color: Colors.white24)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _filteredReservations.length,
                        itemBuilder: (context, index) {
                          final r = _filteredReservations[index];
                          return _buildReservationCard(r);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> r) {
    String nameCn = r['name_cn'] ?? '';
    String nameEn = r['name_en'] ?? '';
    if (_isNameMasked) {
      nameCn = PrivacyUtils.maskChineseName(nameCn);
      nameEn = PrivacyUtils.maskEnglishName(nameEn);
    }
    String ticketTokens = r['ticket_tokens'] ?? '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassmorphismCard(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            '$nameCn ($nameEn)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${r['identity']} · ${r['grade']}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${r['id']} · ${r['time']?.toString().split(' ').first}',
                style: const TextStyle(color: Colors.white24, fontSize: 10, fontFamily: 'Orbitron'),
              ),
              const SizedBox(height: 4),
              Text(
                'Tickets: $ticketTokens',
                style: const TextStyle(color: ThemeConfig.neonCyan, fontSize: 11, fontFamily: 'Orbitron', fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeConfig.neonCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: ThemeConfig.neonCyan.withOpacity(0.3)),
                ),
                child: Text(
                  r['status']?.toString().toUpperCase() ?? '',
                  style: const TextStyle(color: ThemeConfig.neonCyan, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                onPressed: () => _deleteReservation(int.parse(r['id'].toString())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

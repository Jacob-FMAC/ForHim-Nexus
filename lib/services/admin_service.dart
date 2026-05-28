import '../services/api_service.dart';

class AdminService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String password) async {
    return await _api.postAction('admin/login', {'password': password});
  }

  Future<Map<String, dynamic>> getAnalytics() async {
    return await _api.getAction('admin/analytics');
  }

  Future<List<dynamic>> getReservations() async {
    final result = await _api.getAction('admin/reservations');
    return result['data'] ?? [];
  }

  Future<Map<String, dynamic>> validateTicket(String ticketToken, String scannerInfo) async {
    return await _api.postAction('ticket/validate', {
      'ticket_token': ticketToken,
      'scanner_info': scannerInfo,
    });
  }

  Future<Map<String, dynamic>> getSettings() async {
    return await _api.getAction('admin/settings');
  }

  Future<Map<String, dynamic>> updateSettings(Map<String, String> settings) async {
    return await _api.postAction('admin/settings', settings);
  }

  Future<List<dynamic>> getLogs() async {
    final result = await _api.getAction('admin/logs');
    return result['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> deleteReservation(int id) async {
    return await _api.postAction('reservation/delete', {'id': id});
  }
}

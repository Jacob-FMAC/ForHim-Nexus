import '../services/api_service.dart';

class ReservationService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> reserve(Map<String, dynamic> data) async {
    return await _api.postAction('reserve', data);
  }

  Future<Map<String, dynamic>> checkReservation(String fingerprint) async {
    return await _api.postAction('reservation/check', {'fingerprint': fingerprint});
  }

  Future<Map<String, dynamic>> getSystemStatus() async {
    return await _api.getAction('system/status');
  }

  Future<Map<String, dynamic>> getTicketStatus(String ticketToken) async {
    return await _api.getAction('ticket/status', params: {'token': ticketToken});
  }

  Future<Map<String, dynamic>> cancelReservation(String ticketToken) async {
    return await _api.postAction('reservation/cancel', {'token': ticketToken});
  }
}

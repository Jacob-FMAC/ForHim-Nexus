import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../services/reservation_service.dart';
import '../services/storage_service.dart';

class ReservationProvider with ChangeNotifier {
  final ReservationService _service = ReservationService();
  final StorageService _storage = StorageService();

  String? _token;
  String? _fingerprint;
  bool _isLoading = false;
  List<dynamic> _tickets = [];
  bool _isSystemOpen = true;
  String? _openTime;
  String? _closeTime;
  bool _isInitialCheckDone = false;

  String? get token => _token;
  bool get isLoading => _isLoading;
  List<dynamic> get tickets => _tickets;
  bool get isReserved => _token != null;
  bool get isSystemOpen => _isSystemOpen;
  String? get openTime => _openTime;
  String? get closeTime => _closeTime;
  bool get isInitialCheckDone => _isInitialCheckDone;

  Future<void> initialize() async {
    try {
      _token = await _storage.getReservationToken();
      _fingerprint = await _storage.getFingerprint();
      
      if (_fingerprint == null) {
        // Simple fingerprint: platform + timestamp + random
        final raw = '${DateTime.now().millisecondsSinceEpoch}-${StackTrace.current.toString().hashCode}';
        _fingerprint = sha256.convert(utf8.encode(raw)).toString();
        await _storage.saveFingerprint(_fingerprint!);
      }

      await checkSystemStatus();
      
      if (_token != null) {
        await fetchTicketData();
      } else {
        await checkExistingReservation();
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      _isInitialCheckDone = true;
      notifyListeners();
    }
  }

  Future<void> fetchTicketData() async {
    if (_token == null) return;
    try {
      final result = await _service.getTicketStatus(_token!);
      if (result['error'] == null) {
        if (result['tickets'] != null) {
          _tickets = result['tickets'];
        } else {
          _tickets = [result];
        }
        notifyListeners();
      } else if (result['error'].toString().contains('not found')) {
        // If ticket is not found on server, clear local state
        logout();
      }
    } catch (e) {
      debugPrint('Fetch ticket error: $e');
    }
  }

  Future<void> checkExistingReservation() async {
    if (_fingerprint == null) return;
    try {
      final result = await _service.checkReservation(_fingerprint!);
      final reserved = result['reserved'];
      if (reserved == true || reserved == 1) {
        _token = result['token'];
        if (result['tickets'] != null) {
          _tickets = result['tickets'];
        }
        await _storage.saveReservationToken(_token!);
        notifyListeners();
      } else if (_token != null) {
        // If we had a token but server says not reserved anymore, clear it
        logout();
      }
    } catch (e) {
      debugPrint('Check reservation error: $e');
    }
  }

  Future<bool> reserve(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final submission = Map<String, dynamic>.from(data);
      submission['fingerprint'] = _fingerprint;
      
      final result = await _service.reserve(submission);
      final success = result['success'];
      if (success == true || success == 1) {
        _token = result['token'];
        if (result['tickets'] != null) {
          _tickets = result['tickets'];
        }
        await _storage.saveReservationToken(_token!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception(result['message'] ?? 'Reservation failed');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> cancelReservation() async {
    if (_token == null) return false;
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _service.cancelReservation(_token!);
      if (result['success'] == true || result['success'] == 1) {
        // Update local ticket status
        for (var t in _tickets) {
          t['status'] = 'Cancelled';
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception(result['message'] ?? 'Cancellation failed');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void logout() async {
    _token = null;
    _tickets = [];
    await _storage.clearAll();
    notifyListeners();
  }

  Future<void> checkSystemStatus() async {
    try {
      final result = await _service.getSystemStatus();
      _isSystemOpen = result['is_open'] ?? true;
      _openTime = result['open_time'];
      _closeTime = result['close_time'];
      notifyListeners();
    } catch (e) {
      debugPrint('Check system status error: $e');
    }
  }
}

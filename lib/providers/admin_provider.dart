import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../services/storage_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _service = AdminService();
  final StorageService _storage = StorageService();

  String? _adminToken;
  bool _isLoading = false;
  Map<String, String> _settings = {};

  String? get adminToken => _adminToken;
  bool get isLoggedIn => _adminToken != null;
  bool get isLoading => _isLoading;
  Map<String, String> get settings => _settings;

  Future<void> initialize() async {
    _adminToken = await _storage.getAdminToken();
    notifyListeners();
  }

  Future<bool> login(String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.login(password);
      final success = result['success'];
      if (success == true || success == 1) {
        _adminToken = result['token'];
        await _storage.saveAdminToken(_adminToken!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    _adminToken = null;
    await _storage.removeAdminToken();
    notifyListeners();
  }

  Future<void> fetchSettings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _service.getSettings();
      _settings = Map<String, String>.from(data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> updateSettings(Map<String, String> newSettings) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _service.updateSettings(newSettings);
      final success = result['success'];
      if (success == true || success == 1) {
        await fetchSettings();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

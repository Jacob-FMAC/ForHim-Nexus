import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Reservation Token
  Future<void> saveReservationToken(String token) async {
    await init();
    await _prefs!.setString(AppConstants.keyReservationToken, token);
  }

  Future<String?> getReservationToken() async {
    await init();
    return _prefs!.getString(AppConstants.keyReservationToken);
  }

  // Fingerprint
  Future<void> saveFingerprint(String fingerprint) async {
    await init();
    await _prefs!.setString(AppConstants.keyFingerprint, fingerprint);
  }

  Future<String?> getFingerprint() async {
    await init();
    return _prefs!.getString(AppConstants.keyFingerprint);
  }

  // Admin Token
  Future<void> saveAdminToken(String token) async {
    await init();
    await _prefs!.setString(AppConstants.keyAdminToken, token);
  }

  Future<String?> getAdminToken() async {
    await init();
    return _prefs!.getString(AppConstants.keyAdminToken);
  }

  Future<void> removeAdminToken() async {
    await init();
    await _prefs!.remove(AppConstants.keyAdminToken);
  }

  // Form State
  Future<void> saveFormState(Map<String, dynamic> state) async {
    await init();
    await _prefs!.setString(AppConstants.keyFormState, jsonEncode(state));
  }

  Future<Map<String, dynamic>?> getFormState() async {
    await init();
    final data = _prefs!.getString(AppConstants.keyFormState);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // Language
  Future<void> saveLanguage(String language) async {
    await init();
    await _prefs!.setString(AppConstants.keyLanguage, language);
  }

  Future<String?> getLanguage() async {
    await init();
    return _prefs!.getString(AppConstants.keyLanguage);
  }

  // Clear All
  Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }

  // Auth methods
  Future<void> saveAuthToken(String token) async {}
  Future<void> removeAuthToken() async {}
  Future<String?> getAuthToken() async => null;
  Future<void> saveUserId(String id) async {}
  Future<void> removeUserId() async {}
  Future<void> saveUserData(dynamic user) async {}
  Future<void> removeUserData() async {}
}

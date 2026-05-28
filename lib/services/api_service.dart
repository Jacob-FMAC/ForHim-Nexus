import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storage = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final adminToken = await _storage.getAdminToken();
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (adminToken != null) 'Authorization': 'Bearer $adminToken',
    };
  }

  Future<Map<String, dynamic>> postAction(String action, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final url = '${AppConstants.apiBaseUrl}/${AppConstants.apiActionPrefix}$action';
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: {'data': jsonEncode(data)},
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      print('API Request Error ($action): $e');
      throw Exception('Request failed: $e');
    }
  }

  Future<Map<String, dynamic>> getAction(String action, {Map<String, String>? params}) async {
    try {
      final headers = await _getHeaders();
      String url = '${AppConstants.apiBaseUrl}/${AppConstants.apiActionPrefix}$action';
      if (params != null) {
        params.forEach((key, value) {
          url += '&$key=${Uri.encodeComponent(value)}';
        });
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    // Use bodyBytes to avoid crash from duplicate/invalid Content-Type headers
    final bodyStr = utf8.decode(response.bodyBytes);
    print('API Response (${response.statusCode}): $bodyStr');
    if (bodyStr.isEmpty) return {};

    Map<String, dynamic>? body;
    try {
      final decoded = jsonDecode(bodyStr);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      } else if (decoded is List) {
        body = {'data': decoded};
      }
    } catch (e) {
      print('JSON Parse Error: $e | Raw body: $bodyStr');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body ?? {'raw': bodyStr};
    } else {
      final msg = body?['message'] ?? 'Request failed with status: ${response.statusCode}';
      throw Exception(msg);
    }
  }

  // Auth methods
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async => {};
  Future<Map<String, dynamic>> get(String path) async => {};
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async => {};
  Future<String> uploadFile(String path, String filePath) async => '';
}

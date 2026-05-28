import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  Future<User> login(String email, String password) async {
    try {
      final response = await _api.post('auth/login', {
        'email': email,
        'password': password,
      });

      final token = response['data']['token'] as String;
      final userData = response['data']['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      await _storage.saveAuthToken(token);
      await _storage.saveUserId(user.id);
      await _storage.saveUserData(user);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String nickname,
    String gender = 'Other',
  }) async {
    try {
      final response = await _api.post('auth/register', {
        'email': email,
        'password': password,
        'nickname': nickname,
        'gender': gender,
      });

      final token = response['data']['token'] as String;
      final userData = response['data']['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      await _storage.saveAuthToken(token);
      await _storage.saveUserId(user.id);
      await _storage.saveUserData(user);

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _api.post('auth/logout', {});
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      await _storage.removeAuthToken();
      await _storage.removeUserId();
      await _storage.removeUserData();
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final token = await _storage.getAuthToken();
      if (token == null) return null;

      final response = await _api.get('auth/me');
      final userData = response['data'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      await _storage.saveUserData(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.getAuthToken();
    return token != null;
  }

  Future<User> updateProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _api.put('users/profile', updates);
      final userData = response['data'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      await _storage.saveUserData(user);
      return user;
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  Future<String> uploadAvatar(String filePath) async {
    try {
      return await _api.uploadFile('users/avatar', filePath);
    } catch (e) {
      throw Exception('Avatar upload failed: $e');
    }
  }

  Future<String> uploadCoverImage(String filePath) async {
    try {
      return await _api.uploadFile('users/cover', filePath);
    } catch (e) {
      throw Exception('Cover image upload failed: $e');
    }
  }
}

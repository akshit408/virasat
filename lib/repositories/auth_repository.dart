import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return response.data;
      }
    } catch (e) {
      // Fallback response for offline mode
    }
    return null;
  }

  Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String password,
    String role = 'buyer',
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });

      if (response.statusCode == 201 && response.data['success'] == true) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return response.data;
      }
    } catch (e) {
      // Fallback
    }
    return null;
  }

  Future<UserModel?> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      if (response.statusCode == 200 && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      }
    } catch (e) {
      // Fallback
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

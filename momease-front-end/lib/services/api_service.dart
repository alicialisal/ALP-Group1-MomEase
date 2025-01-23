import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL untuk API (ganti sesuai dengan URL backend Anda)
  static const String _baseUrl = 'http://127.0.0.1:8000/api';

  // Instance Dio untuk membuat request HTTP
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api', // Ganti dengan URL backend Anda
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Key untuk menyimpan token di SharedPreferences
  static const String _authTokenKey = 'auth_token';

  // Fungsi untuk menyimpan token ke SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // Fungsi untuk mengambil token dari SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Fungsi untuk menghapus token dari SharedPreferences (digunakan saat logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  // Fungsi untuk menambahkan interceptor untuk menyertakan token di setiap request
  void _addAuthorizationInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
            if (e.response?.statusCode == 401) {
              // Token expired atau tidak valid, lakukan logout atau refresh token
              await removeToken(); 
              // Tambahkan logika untuk redirect ke halaman login atau refresh token
            }
            return handler.next(e);
        },
      ),
    );
  }

  // Constructor untuk menambahkan interceptor saat instance ApiService dibuat
  ApiService() {
    _addAuthorizationInterceptor();
  }

  // Fungsi untuk menangani error Dio
  Map<String, dynamic> _handleDioError(DioError e) {
    if (e.response != null) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'An error occurred.',
        'errors': e.response?.data['errors'],
      };
    } else {
      return {
        'success': false,
        'message': 'Unable to connect to the server.',
      };
    }
  }

  // Fungsi untuk menangani error umum
  Map<String, dynamic> _handleError(dynamic e) {
    return {
      'success': false,
      'message': 'Unexpected error occurred: ${e.toString()}',
    };
  }

  // Fungsi login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'passUsr': password, // Sesuaikan dengan field password di backend
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _saveToken(token);
        return {
          'success': true,
          'user': response.data['user'],
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed. Please try again.',
        };
      }
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Fungsi register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/register',
        data: userData,
      );

      if (response.statusCode == 201) {
        final token = response.data['token'];
        await _saveToken(token);
        return {
          'success': true,
          'message': 'Registration successful.',
          'user': response.data['user'],
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed. Please try again.',
        };
      }
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Fungsi logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _dio.post('/logout'); // Sesuaikan dengan endpoint logout di backend

      if (response.statusCode == 200) {
        await removeToken();
        return {
          'success': true,
          'message': 'Logout successful.',
        };
      } else {
        return {
          'success': false,
          'message': 'Logout failed.',
        };
      }
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Fungsi untuk mendapatkan profil user
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/profile/show'); // Sesuaikan dengan endpoint profile di backend

      if (response.statusCode == 200) {
        return {
          'success': true,
          'profile': response.data['profile'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load profile data.',
        };
      }
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleError(e);
    }
  }

Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/profile/update',
        data: profileData,
      );
      
      return {
        'success': true,
        'profile': response.data['profile'],
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to update profile',
      };
    }
  }
}

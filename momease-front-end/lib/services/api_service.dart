import 'package:dio/dio.dart';

class ApiService {
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

  // Fungsi login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'passUsr': password,
        },
      );

      if (response.statusCode == 200) {
        print('Response user: ${response.data['user']}');
        print('Response token: ${response.data['token']}');
        return {
          'success': true,
          'user': response.data['user'],
          'token': response.data['token'],
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed. Please try again.',
        };
      }
    } on DioError catch (e) {
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
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error occurred.',
      };
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
        return {
          'success': true,
          'message': 'Registration successful.',
          'user': response.data['user'],
          'token': response.data['token'],
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed. Please try again.',
        };
      }
    } on DioError catch (e) {
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
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error occurred.',
      };
    }
  }
}

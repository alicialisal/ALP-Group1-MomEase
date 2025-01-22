import 'package:dio/dio.dart';

class JournalingService {
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

  // Map<DateTime, Map<String, dynamic>> _moodData = {};

  // Fungsi untuk mengambil data mood dari API
  Future<Map<DateTime, Map<int, dynamic>>> fetchMoodSummary(String bearerToken, int idUser) async {
    // Validasi parameter idUser
    if (idUser <= 0) {
      throw Exception('Invalid idUser');
    }

    // Mendapatkan bulan dan tahun saat ini
    DateTime now = DateTime.now();
    int month = now.month; // Bulan dalam bentuk angka (1-12)
    int year = now.year;   // Tahun dalam bentuk angka (contoh: 2025)
    
    try {
      final response = await _dio.get(
        '/mood-summary',
        queryParameters: {'idUser': idUser, 'month': month, 'year':year}, // Menambahkan idUser sebagai query parameter jika diperlukan
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> moodData = data['data'];

        // Mengubah data menjadi Map<DateTime, Map<int, dynamic>>
        Map<DateTime, Map<int, dynamic>> moodMap = {};

        for (var entry in moodData) {
          String dateString = entry['date'];
          int mood = entry['mood'];

          DateTime date = DateTime.parse(dateString);

          // Menambahkan mood ke map berdasarkan tanggal
          if (!moodMap.containsKey(date)) {
            moodMap[date] = {};
          }

          // Menambahkan mood ke dalam Map<int, dynamic> per tanggal
          int moodCount = moodMap[date]!.length + 1;
          moodMap[date]![moodCount] = mood;
        }

        return moodMap;
      } else {
        throw Exception('Failed to load mood data');
      }
    } catch (e) {
      throw Exception('Error fetching mood data: $e');
    }
  }

  // Fungsi journaling
  Future<Map<String, dynamic>> saveMood(Map<String, dynamic> journalingData, String bearerToken) async {
    try {
      final response = await _dio.post(
        '/journaling',
        data: journalingData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Saved successfully.',
          'user': response.data['user'],
          'token': response.data['token'],
        };
      } else {
        return {
          'success': false,
          'message': 'Save failed. Please try again.',
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
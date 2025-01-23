import 'dart:convert';

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
  Future<Map<DateTime, Map<String, dynamic>>> fetchMoodHistory(String bearerToken, int idUser) async {
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
        '/mood-details',
        queryParameters: {'idUser': idUser, 'month': month, 'year':year},
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Mengambil data dari response dan melakukan konversi
        Map<String, dynamic> data = response.data as Map<String, dynamic>;

        // Mendapatkan data array yang ada di dalam key 'data'
        List<dynamic> moodData = data['data'];

        // Mengonversi List<dynamic> menjadi Map<DateTime, Map<int, dynamic>>
        Map<DateTime, Map<String, dynamic>> result = {};

        for (var entry in moodData) {
          // Mengonversi tanggal dari string menjadi DateTime
          DateTime date = DateTime.parse(entry['date']);

          // Menyusun data mood dalam Map untuk setiap tanggal
          result[date] = {
            'idUser': entry['idUser'],
            'mood': entry['mood'],
            'perasaan': List<String>.from(jsonDecode(entry['perasaan'])),
            'kondisiBayi': List<String>.from(jsonDecode(entry['kondisiBayi'])),
            'textJurnal': entry['textJurnal'],
          };
        }

        return result;
      } else {
        throw Exception('Failed to load mood detail');
      }
    } catch (e) {
      throw Exception('Error fetching mood data: $e');
    }
  }

  // Fungsi untuk mengambil data mood dari API
  Future<Map<DateTime, Map<String, dynamic>>> fetchDetailMood(
      String bearerToken, int idUser, DateTime date) async {
    // Validasi parameter idUser
    if (idUser <= 0) {
      throw Exception('Invalid idUser');
    }
  
    // Mendapatkan bulan dan tahun saat ini
    DateTime now = DateTime.now();
    String todayDate =
        date.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
    int month = now.month; // Bulan dalam bentuk angka (1-12)
    int year = now.year; // Tahun dalam bentuk angka (contoh: 2025)
  
    try {
      final response = await _dio.get(
        '/journaling/$idUser/$todayDate',
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );
  
      if (response.statusCode == 200) {
        // Mengambil data dari response dan melakukan konversi
        Map<String, dynamic> data = response.data as Map<String, dynamic>;
  
        if (data.containsKey('data')) {
          var entry = data['data'];
          print('Entry Data: $entry'); // Debugging: Memeriksa data entry
  
          // Mengonversi tanggal dari string menjadi DateTime
          DateTime date = DateTime.parse(entry['tglInput']);
          print('Parsed Date: $date'); // Debugging: Memeriksa tanggal yang diparse
  
          // Menyusun data mood dalam Map
          Map<DateTime, Map<String, dynamic>> result = {
            date: {
              'idJournaling': entry['idJournaling'],
              'idUser': entry['idUser'],
              'mood': entry['mood'],
              'perasaan': List<String>.from(jsonDecode(entry['perasaan'])),
              'kondisiBayi': List<String>.from(jsonDecode(entry['kondisiBayi'])),
              'textJurnal': entry['textJurnal'],
            }
          };
  
          return result;
        } else {
          throw Exception('Response does not contain expected data');
        }
      } else {
        throw Exception('Failed to load mood detail');
      }
    } catch (e) {
      throw Exception('Error fetching mood data: $e');
    }
  }


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
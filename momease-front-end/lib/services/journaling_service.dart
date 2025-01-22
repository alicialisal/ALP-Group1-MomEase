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

// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future<void> saveMood({
//   required int idUser,
//   required String mood,
//   required List<String> perasaan,
//   required List<String> kondisiBayi,
//   required String textJurnal,
//   String? imagePath,
// }) async {
//   final url = Uri.parse('http://127.0.0.1:8000/api/journaling'); // Ganti dengan URL API Anda
//   final request = http.MultipartRequest('POST', url);

//   // Tambahkan data ke request
//   request.fields['idUser'] = idUser.toString();
//   request.fields['tglInput'] = DateTime.now().toIso8601String();
//   request.fields['mood'] = mood;
//   request.fields['perasaan'] = jsonEncode(perasaan);
//   request.fields['kondisiBayi'] = jsonEncode(kondisiBayi);
//   request.fields['textJurnal'] = textJurnal;

//   // Tambahkan file jika ada
//   if (imagePath != null) {
//     request.files.add(await http.MultipartFile.fromPath('image', imagePath));
//   }

//   // Kirim request
//   final response = await request.send();

//   // Periksa respons
//   if (response.statusCode == 200) {
//     final responseBody = await response.stream.bytesToString();
//     final responseData = json.decode(responseBody);
//     print('Data berhasil disimpan: $responseData');
//   } else {
//     print('Gagal menyimpan data: ${response.statusCode}');
//   }
// }

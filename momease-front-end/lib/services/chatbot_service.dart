// service_chatbot.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotService {
  final String _baseUrl = 'YOUR_LARAVEL_API_BASE_URL';

  Future<Map<String, dynamic>> sendMessage(String idSesi, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ambil token dari SharedPreferences

    final url = Uri.parse('$_baseUrl/chat/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'idSesi': idSesi, 'pesan': message});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}
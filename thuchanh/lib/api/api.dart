import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class Api {
  static const String baseUrl =
      "http://192.168.15.109:8000/api/users"; // Thay thế bằng URL của API của bạn

  static Future<Map<String, dynamic>> login(User user) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode(user.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'message': data['message']};
    } else {
      final error = jsonDecode(response.body);
      return {'success': false, 'message': error['message']};
    }
  }

  static Future<Map<String, dynamic>> register(User user) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode(user.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'message': data['message']};
    } else {
      final error = jsonDecode(response.body);
      return {'success': false, 'message': error['message']};
    }
  }
}

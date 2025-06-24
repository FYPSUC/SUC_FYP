import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2/flutter_api';

  static Future<Map<String, dynamic>> registerUser(
    String username,
    String password,
    String email,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        body: {
          'username': username,
          'password': password,
          'email': email,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': '服务器返回错误，状态码：${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': '请求失败：$e'};
    }
  }

  static Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': '服务器返回错误，状态码：${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': '请求失败：$e'};
    }
  }
}

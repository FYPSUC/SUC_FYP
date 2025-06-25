import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.75.128/flutter_api';

  /// 🔸旧方法：传统注册
  static Future<Map<String, dynamic>> legacyRegisterUser(
      String username,
      String password,
      String email,
      String role,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
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

  /// ✅ 新方法：Firebase 注册
  static Future<Map<String, dynamic>> registerUser(
      String uid,
      String username,
      String email,
      String role,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'uid': uid,
          'username': username,
          'email': email,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Request failed: $e'};
    }
  }

  /// ✅ 只查 users 表（用于 User 登录）
  static Future<Map<String, dynamic>> getUserByUID(String uid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_user_by_uid.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'uid': uid},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Request failed: $e'};
    }
  }

  /// ✅ 只查 vendor 表（用于 Vendor 登录）
  static Future<Map<String, dynamic>> getVendorByUID(String uid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_vendor_by_uid.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'uid': uid},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Request failed: $e'};
    }
  }

  /// ✅ 用户登录 API（如果仍需支持 username 登录）
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
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

  /// ✅ Vendor 登录（如果仍需支持 username 登录）
  static Future<Map<String, dynamic>> loginVendor(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vendorlogin.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': username},
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
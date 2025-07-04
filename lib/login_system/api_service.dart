import 'package:http/http.dart' as http;
import 'dart:convert';


class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://c63f-2001-e68-540a-2857-81e-2c8f-7a64-285f.ngrok-free.app/flutter_api/',
  );

  /// 🔸旧方法：传统注册
  static Future<Map<String, dynamic>> legacyRegisterUser(String username,
      String password,
      String email,
      String role,) async {
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
  static Future<Map<String, dynamic>> registerUser(String uid,
      String username,
      String email,
      String role,) async {
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
  static Future<Map<String, dynamic>> loginUser(String username,
      String password) async {
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
  static Future<Map<String, dynamic>> sendResetOtp(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send_reset_otp.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'new_password': newPassword,
      },
    );
    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> sendVendorResetOtp(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send_vendor_reset.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'new_password': newPassword,
      },
    );
    return jsonDecode(response.body);
  }



  static Future<Map<String, dynamic>> getUserBalance(String uid) async {
    final url = Uri.parse('$baseUrl/get_user_balance.php');
    final response = await http.post(url, body: {'uid': uid});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return {'success': false, 'message': 'Failed to connect to server'};
    }
  }

  static Future<double?> fetchUserBalance(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_balance.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'user_id': userId},
    );
    final result = jsonDecode(response.body);
    return result['success']
        ? double.parse(result['balance'].toString())
        : null;
  }

  static Future<bool> topUpUser(String userId, double amount,
      {String role = 'users'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topup_user.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'user_id': userId,
        'amount': amount.toStringAsFixed(2),
        'role': role,
      },
    );
    final result = jsonDecode(response.body);
    return result['success'];
  }


  static Future<double?> fetchVendorBalance(String vendorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_balance.php'), // 没错，复用同一个 PHP 文件
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'uid': vendorId, 'role': 'vendor'}, // 增加 role 字段
    );
    final result = jsonDecode(response.body);
    return result['success']
        ? double.parse(result['balance'].toString())
        : null;
  }


  static Future<Map<String, dynamic>> updateUserProfile({
    required String uid,
    required String username,
    required String ImageUrl,
    required String SixDigitPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_user_profile.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'uid': uid,
          'username': username,
          'Image_url': ImageUrl,
          'SixDigitPassword': SixDigitPassword,
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

}

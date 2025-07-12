import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:suc_fyp/Order_User/models.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class ApiService {
  //static String baseUrl = 'https://default.ngrok-free.app/flutter_api/';
  //static const String baseUrl = 'https://567e42c94263.ngrok-free.app/flutter_api/';
  static late String baseUrl;

  static Future<void> init() async {
    baseUrl = await ApiService.getBaseUrl();
  }
  static Future<String> getBaseUrl() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 0), // Debug 时强制刷新
    ));

    try {
      final success = await remoteConfig.fetchAndActivate();
      print('🔧 RemoteConfig fetch success: $success');

      final url = remoteConfig.getString('baseUrl');
      print('🐛 Raw baseUrl: $url');

      return url.isNotEmpty
          ? url
          : 'https://fallback.ngrok-free.app/flutter_api/';
    } catch (e) {
      print('❌ RemoteConfig error: $e');
      return 'https://fallback.ngrok-free.app/flutter_api/';
    }
  }




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
        Uri.parse('$baseUrl/login_vendor.php'),
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
      {String role = 'User'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topup_user.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'uid': userId,
        'amount': amount.toStringAsFixed(2),
        'role': role,
      },
    );
    final result = jsonDecode(response.body);
    return result['success'];
  }
// ✅ 通用 Top-Up 方法（适用于 User 和 Vendor）
  static Future<bool> topUp(String uid, double amount, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topup_user.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'uid': uid,
        'amount': amount.toStringAsFixed(2),
        'role': role,
      },
    );

    final result = jsonDecode(response.body);
    print('🟢 TopUp Result: $result');
    return result['success'];
  }

  static Future<double?> fetchBalance(String uid, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_balance.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'uid': uid,
        'role': role,
      },
    );

    final result = jsonDecode(response.body);
    return result['success'] ? double.tryParse(result['balance'].toString()) : null;
  }
  static Future<bool> topUpVendor(String vendorId, double amount,
      {String role = 'Vendor'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topup_user.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'uid': vendorId,
        'amount': amount.toStringAsFixed(2),
        'role': 'Vendor',
      },
    );
    final result = jsonDecode(response.body);
    print('🟢 TopUp Vendor Result: $result');
    return result['success'];
  }


  static Future<double?> fetchVendorBalance(String vendorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_balance.php'), // 没错，复用同一个 PHP 文件
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'uid': vendorId,
        'role': 'Vendor',
      }, // 增加 role 字段
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
          'image_url': ImageUrl,
          'SixDigitPassword': SixDigitPassword,
          'role':'User',
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
  static Future<Map<String, dynamic>> updateVendorProfile({
    required String uid,
    required String image_url,
    required String ShopName,
    required String PickupAddress,
    required String SixDigitPassword,
    String AdShopImage = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_user_profile.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'uid': uid,
          'role': 'Vendor',
          'image_url': image_url,
          'ShopName': ShopName,
          'PickupAddress': PickupAddress,
          'SixDigitPassword': SixDigitPassword,
          'AdShopImage': AdShopImage,
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

  // 在 api_service.dart 中添加
  static Future<Map<String, dynamic>> getQRDataByUID(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/get_qr_by_uid.php?uid=$uid'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load QR data');
    }
  }

  static Future<Map<String, dynamic>> transferFunds({
    required String SenderID,
    required String ReceiverID,
    required String Amount,
    required String SixDigitPassword,
    int? orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transfer_funds.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'sender_uid': SenderID,
          'receiver_uid': ReceiverID,
          'amount': Amount,
          'SixDigitPassword': SixDigitPassword,
          if (orderId != null) 'order_id': orderId.toString(),
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

  static Future<bool> addProduct({
    required String uid, // ✅ 改成 uid，与 updateVendorProfile 统一
    required String name,
    required double price,
    required String image_url,
  }) async {
    final url = Uri.parse('$baseUrl/add_product.php');
    final response = await http.post(url, body: {
      'uid': uid, // ✅ 与 updateVendorProfile 统一字段
      'ProductName': name,
      'ProductPrice': price.toString(),
      'image_url': image_url,
    });

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  static Future<List<Map<String, dynamic>>> getVendorProducts(String uid) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_vendor_products.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'uid': uid},
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      return List<Map<String, dynamic>>.from(data['products']);
    } else {
      return [];
    }
  }

  static Future<bool> deleteProduct(String productID) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_product.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'ProductID': productID},
    );

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }
  static Future<bool> updateProduct({
    required String productID,
    required String name,
    required double price,
  }) async {
    final url = Uri.parse('$baseUrl/update_product.php');
    final response = await http.post(url, body: {
      'ProductID': productID,
      'ProductName': name,
      'ProductPrice': price.toString(),
    });

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  static Future<List<Store>> fetchStoresWithProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_stores_with_products.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['success']) {
        return (jsonData['stores'] as List)
            .map((storeJson) => Store.fromJson(storeJson))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load stores');
    }
  }

  static Future<Map<String, dynamic>> createVoucher({
    required String firebaseUID,
    required String name,
    required double amount,
    required DateTime expiredDate,
  }) async {
    final url = Uri.parse('$baseUrl/create_voucher.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "firebaseUID": firebaseUID,
        "name": name,
        "amount": amount,
        "expiredDate": expiredDate.toIso8601String(),
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<Map<String, dynamic>>> getVendorVouchers(String firebaseUID) async {
    final url = Uri.parse('$baseUrl/get_vendor_vouchers.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'firebaseUID': firebaseUID}),
    );

    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['vouchers']);
    } else {
      return [];
    }
  }

  static Future<bool> deleteVoucher(String voucherId) async {
    final url = Uri.parse('$baseUrl/delete_voucher.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'voucherID': voucherId}),
    );

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  static Future<bool> updateVoucher({
    required String voucherId,
    required String name,
    required String discount,
    required String expiredDate, // yyyy-MM-dd
  }) async {
    final url = Uri.parse('$baseUrl/update_voucher.php');

    print('📤 Sending POST request to $url');
    print('📤 Payload:');
    print({
      'voucherId': voucherId,
      'name': name,
      'discount': discount,
      'expiredDate': expiredDate,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'voucherId': voucherId,
          'name': name,
          'discount': double.parse(discount),
          'expiredDate': expiredDate,
        }),
      );

      print('🔁 Status Code: ${response.statusCode}');
      print('🔁 Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('❌ Exception while calling update_voucher.php: $e');
      return false;
    }
  }

  static Future<List<Voucher>> getAllVouchers() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_active_vouchers.php'));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Voucher.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<bool> claimVoucher(String firebaseUID, int voucherID) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/claim_voucher.php'),
        body: {
          'firebase_uid': firebaseUID,
          'voucher_id': voucherID.toString(),
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('❌ claimVoucher error: $e');
      return false;
    }
  }


  static Future<List<int>> getCollectedVoucherIds(String firebaseUID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_user_collected_vouchers.php?firebase_uid=$firebaseUID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => int.parse(e.toString())).toList();
    } else {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getVendorOrders(String vendorUID) async {
    final resp = await http.get(Uri.parse('$baseUrl/get_vendor_orders.php?vendor_uid=$vendorUID'));
    if (resp.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(resp.body));
    }
    return [];
  }

  static Future<Map<String, dynamic>> placeOrder({
    required String firebaseUID,
    required String vendorUID,
    required double total,
    String? voucherID,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/place_order.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "firebase_uid": firebaseUID,
        "vendor_uid": vendorUID,
        "total": total,
        "voucher_id": voucherID,
        "items": items,
      }),
    );

    return jsonDecode(response.body); // 👈 返回完整 map 而不是 true/false
  }


  static Future<Map<String, dynamic>> getOrderStatus(int orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_order_status.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"order_id": orderId}),
    );

    return jsonDecode(response.body);
  }


  static Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_order_status.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_id': orderId,
        'status': newStatus,
      }),
    );

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  static Future<Map<String, dynamic>> getUserTransactions(String firebaseUID) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_transactions.php'),
      body: {'firebase_uid': firebaseUID},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Failed to connect'};
    }
  }

  static Future<Map<String, dynamic>> getVendorTransactions(String uid) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_vendor_transactions.php'),
      body: {'firebase_uid': uid},
    );

    final data = jsonDecode(response.body);
    return data;
  }

  static Future<Map<String, dynamic>> getOrderById(int orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_order_by_id.php'),
      body: {'order_id': orderId.toString()},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('API error: ${response.statusCode}');
      return {"success": false};
    }
  }

  static Future<bool> bookAppointment({
    required String firebaseUID,
    required String datetime,
    required String note,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/book_appointment.php'),
      body: {
        'uid': firebaseUID,
        'datetime': datetime,
        'note': note,
      },
    );

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  static Future<List<Map<String, dynamic>>> getUserAppointments(String firebaseUID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_appointments_by_uid.php?uid=$firebaseUID'),
    );

    final data = jsonDecode(response.body);
    if (data['success'] == true && data['appointments'] is List) {
      return List<Map<String, dynamic>>.from(data['appointments']);
    } else {
      return [];
    }
  }




}





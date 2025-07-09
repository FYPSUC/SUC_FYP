import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/main.dart';
import 'QR/QR.dart';
import 'UserProfile.dart';
import 'TopUp.dart';
import 'TransactionHistory.dart';
import '../Clinic_User/Clinic.dart';
import '../Order_User/Order.dart';
import 'Voucher.dart';
import '../Order_User/OrderPurchase.dart';
import 'package:suc_fyp/Order_User/models.dart' as models;

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  double balance = 0.00;
  bool showBalance = true;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadBalance();
  }

  Future<void> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    final role = prefs.getString('role');
    print("🔎 SharedPreferences keys: ${prefs.getKeys()}");
    print("🔎 uid: ${prefs.getString('uid')}");
    print("🔎 role: ${prefs.getString('role')}");
    print("📦 UID: $uid, Role: $role");

    if (uid == null || role == null) {
      print("❌ Balance fetch failed: Missing uid or role");
      return;
    }

    try {
      // 🟢 获取余额
      final fetchedBalance = await ApiService.fetchBalance(uid, role); // 应该返回 double 类型

      if (fetchedBalance != null) {
        setState(() {
          balance = fetchedBalance;
        });
      } else {
        print("❌ Balance fetch failed: balance is null");
      }

      // 🟢 获取用户资料
      final userResponse = await ApiService.getUserByUID(uid);
      if (userResponse['success']) {
        setState(() {
          _profileImageUrl = userResponse['user']['Image'];
        });
      } else {
        print("❌ Failed to load user profile image: ${userResponse['message']}");
      }

    } catch (e) {
      print("❌ Error loading balance/profile: $e");
    }
  }


  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/UserMainBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight(context) * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: screenWidth(context) * 0.06,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: screenWidth(context) * 0.24,
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 0.02),
                          Row(
                            children: [
                              Text(
                                showBalance ? 'RM ${balance.toStringAsFixed(2)}' : 'RM ****',
                                style: TextStyle(
                                  fontSize: screenWidth(context) * 0.08,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showBalance ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showBalance = !showBalance;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: const CircleBorder(),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserProfilePage()),
                          ).then((_) => loadBalance()); // 👈 refresh on return
                        },
                        child: Container(
                          width: screenWidth(context) * 0.28,
                          height: screenWidth(context) * 0.28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                                  ? NetworkImage(_profileImageUrl!)
                                  : const AssetImage('assets/image/Profile_icon.png') as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight(context) * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth(context) * 0.04,
                            vertical: screenHeight(context) * 0.015,
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserTopUpPage()),
                          ).then((value) {
                            if (value == true) {
                              loadBalance(); // ✅ Only reload if TopUp was successful
                            }
                          });
                        },
                        child: Text(
                          '+ Top up',
                          style: TextStyle(
                            fontSize: screenWidth(context) * 0.06,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UserTransactionHistoryPage()));
                        },
                        child: Text(
                          'Transaction history >',
                          style: TextStyle(
                            fontSize: screenWidth(context) * 0.045,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.black),
                  SizedBox(height: screenHeight(context) * 0.02),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      padding: const EdgeInsets.all(20),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildMenuButton('QR code', 'assets/image/QR_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage()));
                        }),
                        _buildMenuButton('Voucher', 'assets/image/Voucher_icon.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserVoucherPage(
                                onVoucherSelected: (voucher) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderSummaryPage(
                                        selectedItems: {
                                          models.MenuItem(
                                            name: 'Example Item',
                                            price: 6.0,
                                            image: 'assets/image/example.png',
                                          ): 1
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                        _buildMenuButton('Order', 'assets/image/Order_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserOrderPage()));
                        }),
                        _buildMenuButton('Clinic', 'assets/image/Clinic_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserClinicPage()));
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: screenWidth(context) * 0.25, height: screenWidth(context) * 0.25),
            SizedBox(height: screenHeight(context) * 0.015),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

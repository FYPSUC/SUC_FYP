import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/main.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'QR/QR.dart';
import 'UserProfile.dart';
import 'dart:convert';
import 'TopUp.dart';
import 'TransactionHistory.dart';
import '../Clinic_User/Clinic.dart';
import '../Order_User/Order.dart';
import 'Voucher.dart';
import '../Order_User/OrderPurchase.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:suc_fyp/Order_User/models.dart' as models;

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> with WidgetsBindingObserver {
  double balance = 0.00;
  bool showBalance = true;
  String? _profileImageUrl;
  final GlobalKey _profileKey = GlobalKey();
  List<Map<String, dynamic>> _notifications = [];
  bool _showNotificationPopup = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadBalance();
    loadNotifications();
    checkAndShowGuide();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 当 App 从后台回来时刷新数据
      loadBalance();
      loadNotifications();
    }
  }


  Future<void> checkAndShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('user_guide_shown') ?? false;

    if (!shown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTutorial();
      });
    }
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          keyTarget: _profileKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Text(
                "点击这里可以设置头像与昵称 Click here to edit profile",
                style: TextStyle(fontSize: 20, color: Colors.lightBlue),
              ),
            ),
          ],

        ),
      ],
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('user_guide_shown', true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserProfilePage(showSecondGuide: true)),
        );
      },
    ).show(context: context);
  }


  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();


    final uid = prefs.getString('uid');
    if (uid == null) return;

    final result = await ApiService.getUserNotifications(uid);
    print("📬 Received notifications: $result");

    final newNotifications = <Map<String, dynamic>>[];

    // ✅ 使用字符串集合记录所有 message
    final shownMessages = Set<String>.from(
      jsonDecode(prefs.getString('shown_messages') ?? '[]'),
    );

    for (var notification in result) {
      final msg = notification['message'].toString();

      // ✅ 完整以 message 内容作为判重依据
      if (!shownMessages.contains(msg)) {
        newNotifications.add(notification);
        shownMessages.add(msg); // ✅ 加入去重集合
      }
    }

    if (newNotifications.isNotEmpty) {
      print("✅ Will show popup for: ${newNotifications.map((e) => e['message'])}");
      setState(() {
        _notifications = newNotifications;
        _showNotificationPopup = true;
      });

      // ✅ 更新缓存
      await prefs.setString('shown_messages', jsonEncode(shownMessages.toList()));
      print("📥 Updated shown_messages: $shownMessages");

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showNotificationPopup = false;
          });
        }
      });
    }
  }






  Future<void> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    final role = prefs.getString('role');

    if (uid == null || role == null) return;

    try {
      final fetchedBalance = await ApiService.fetchBalance(uid, role);
      if (fetchedBalance != null) {
        setState(() {
          balance = fetchedBalance;
        });
      }

      final userResponse = await ApiService.getUserByUID(uid);
      if (userResponse['success']) {
        setState(() {
          _profileImageUrl = userResponse['user']['Image'];
        });
      }
    } catch (e) {
      print("\u274c Error loading balance/profile: $e");
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

          if (_showNotificationPopup && _notifications.isNotEmpty)
            Positioned(
              top: 20,
              right: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _notifications[0]['message'], // 显示第一条通知
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                        key: _profileKey,
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
                          ).then((_) => loadBalance());
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
                              loadBalance();
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
                                            id: 1,
                                            name: 'Example Item',
                                            price: 6.0,
                                            image: 'assets/image/example.png',
                                            isSoldOut: 0,
                                          ): 1
                                        },
                                        vendorUID: 'EXAMPLE_VENDOR_UID',
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
                        _buildMenuButton('Suc Portal', 'assets/image/Portal_icon.png', () async {
                          final url = Uri.parse('https://www.sc.edu.my/sccn_dev/login.php');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }

                        }),
                        _buildMenuButton('Suc E-learning', 'assets/image/Elearning_icon.png', () async {
                          final url = Uri.parse('https://succms.sc.edu.my/login/index.php');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }

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

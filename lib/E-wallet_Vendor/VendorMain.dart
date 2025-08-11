import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/main.dart';
import 'VendorQR/VendorQR.dart';
import 'VendorProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'VendorTopUp.dart';
import 'VendorTransactionHistory.dart';
import 'VendorVoucher/VendorVoucher.dart';
import 'VendorProduct/Product.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'ViewOrder.dart';

class VendorMainPage extends StatefulWidget {
  const VendorMainPage({super.key});

  @override
  State<VendorMainPage> createState() => _VendorMainPageState();
}

class _VendorMainPageState extends State<VendorMainPage> {
  double balance = 0.00;
  bool showBalance = true;
  String? _profileImageUrl;
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _setShopKey = GlobalKey();
  List<TargetFocus> targets = [];
  TutorialCoachMark? tutorialCoachMark;
  final GlobalKey _topUpKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _qrKey = GlobalKey();
  final GlobalKey _voucherKey = GlobalKey();
  final GlobalKey _viewOrderKey = GlobalKey();
  final GlobalKey _productKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadVendorBalance();
    _loadVendorProfileImage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowGuide();  // ✅ 只显示一次
    });
  }


  Future<void> _checkAndShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final step = prefs.getInt('vendor_guide_step') ?? 0;

    if (step == 0) {
      // 第一次进来，显示 VendorMainPage 教学
      buildTargets();
      Future.delayed(const Duration(milliseconds: 500), () {
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.grey,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () async {
          await prefs.setInt('vendor_guide_step', 1); // 下一步为 ProfilePage
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorProfilePage()));
        },
        onClickTarget: (target) => true,
        onSkip: () => true,
      );

      tutorialCoachMark!.show(context: context);
    });
    }
  }


  void buildTargets() {
    targets.clear();

    targets.add(
      TargetFocus(
        identify: "VendorProfile",
        keyTarget: _profileKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text(
              "点击这里可以设置你的店头像以及6位数安全交易码\nClick here to set up your profile and upload 6-digit password",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "SetShop",
        keyTarget: _setShopKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text(
              "设置商店广告图片、名称和取货地址\nSet up vendor AdImage, ShopName and Pickup Address",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "TopUp",
        keyTarget: _topUpKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("点击这里可以充值余额\nClick here to top up your wallet",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "History",
        keyTarget: _historyKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("点击这里可以查看交易记录\nView your transaction history here",
              style: TextStyle(color: Colors.lightBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "QR",
        keyTarget: _qrKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("展示你的收款码，或扫码进行支付\nUse this for QR receive or pay",
              style: TextStyle(color: Colors.lightBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Voucher",
        keyTarget: _voucherKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("创建优惠券以吸引用户\nCreate promotional vouchers here",
              style: TextStyle(color: Colors.lightBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "ViewOrder",
        keyTarget: _viewOrderKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("查看用户下单记录\nView all received orders here",
              style: TextStyle(color: Colors.lightBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Product",
        keyTarget: _productKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("上传你的产品\nManage your product listings here",
              style: TextStyle(color: Colors.lightBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }


  void _loadVendorBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      final vendorBalance = await ApiService.fetchVendorBalance(uid);
      if (vendorBalance != null) {
        setState(() {
          balance = vendorBalance;
        });
      }
    }
  }

  void _loadVendorProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final response = await ApiService.getVendorByUID(user.uid);
      print('📦 Vendor response: $response');
      if (response['success']) {
        final data = response['user'];

        if (data != null && data['Image'] != null && data['Image'].toString().isNotEmpty) {
          String imageUrl = data['Image'];
          print('✅ 加载头像: $imageUrl');

          imageCache.clear();
          imageCache.clearLiveImages();

          setState(() {
            _profileImageUrl = imageUrl;
          });
        } else {
          print('⚠️ 未找到头像链接');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/UserMainBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const HomePage()),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.25,
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Text(
                                showBalance ? 'RM ${balance.toStringAsFixed(2)}' : 'RM ****',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.08,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showBalance ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.black,
                                  size: screenWidth * 0.07,
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

                      GestureDetector(
                        key: _profileKey,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VendorProfilePage()),
                          );
                          if (!mounted) return;
                          setState(() {
                            _profileImageUrl = null;
                          });
                          _loadVendorProfileImage();
                        },
                        child: ClipOval(
                          child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                              ? Image.network(
                            '$_profileImageUrl?t=${DateTime.now().millisecondsSinceEpoch}',
                            key: UniqueKey(),
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.25,
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            'assets/image/Profile_icon.png',
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          elevation: 2,
                        ),
                        key: _topUpKey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VendorTopUpPage()),
                          );
                        },
                        child: Text(
                          '+ Top up',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        key: _historyKey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VendorTransactionHistoryPage()),
                          );
                        },
                        child: Text(
                          'Transaction history >',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: screenHeight * 0.04,
                    thickness: 2,
                    color: Colors.black,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      crossAxisSpacing: screenWidth * 0.04,
                      mainAxisSpacing: screenHeight * 0.02,
                      children: [
                        _buildMenuButton('QR code', 'assets/image/QR_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorQRPage()));
                        }, screenWidth, key: _qrKey),
                        _buildMenuButton('Create Voucher', 'assets/image/Voucher_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorVoucherPage()));
                        }, screenWidth, key: _voucherKey),
                        _buildMenuButton('View Order', 'assets/image/Order_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorViewOrderPage()));
                        }, screenWidth, key: _viewOrderKey),
                        _buildMenuButton('Product', 'assets/image/Product_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorProductPage()));
                        }, screenWidth, key: _productKey),
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

  Widget _buildMenuButton(String title, String imagePath, VoidCallback onTap, double screenWidth, {Key? key}) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
            ),
            SizedBox(height: screenWidth * 0.03),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}

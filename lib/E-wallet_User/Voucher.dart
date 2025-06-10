import 'package:flutter/material.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';

void main() {
  runApp(const UserVoucherPage());
}

class UserVoucherPage extends StatelessWidget {
  const UserVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '优惠券卡片',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: const CouponCardPage(),
    );
  }
}

class CouponCardPage extends StatelessWidget {
  const CouponCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back按钮
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserMainPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/image/BackButton.jpg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 优惠券部分
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CouponCard(
                            merchantName: "The Alley",
                            offer: "RM 5 Off Collect",
                            expiry: "Use before 30/12",
                            logoAsset: "assets/image/Voucher_icon.png",
                          ),
                          SizedBox(height: 20),
                          CouponCard(
                            merchantName: "Chicken Rise Store",
                            offer: "RM 3 Off Any Drink",
                            expiry: "Use before 15/12",
                            logoAsset: "assets/image/Voucher_icon.png",
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CouponCard extends StatefulWidget {
  final String merchantName;
  final String offer;
  final String expiry;
  final String logoAsset;

  const CouponCard({
    super.key,
    required this.merchantName,
    required this.offer,
    required this.expiry,
    required this.logoAsset,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isCollected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 左边logo区域
          Container(
            width: 120,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2596BE),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.logoAsset,
                  fit: BoxFit.contain,
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          ),

          // 右边信息区域
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.merchantName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.offer,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2596BE),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.expiry,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isCollected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PlaceholderPage(),
                              ),
                            );
                          } else {
                            setState(() {
                              isCollected = true;
                            });
                          }
                        },
                        child: Container(
                          width: 75, // 固定宽度，Collect和Use按钮一致
                          height: 40, // 固定高度
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2596BE),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            isCollected ? "Use" : "Collect",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 占位页面
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coming Soon")),
      body: const Center(
        child: Text(
          "This page is under construction.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

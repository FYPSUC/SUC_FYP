import 'package:flutter/material.dart';
import 'package:suc_fyp/main.dart';
import 'VendorQR/VendorQR.dart';
import 'VendorProfile.dart';
import 'VendorTopUp.dart';
import 'VendorTransactionHistory.dart';
import 'VendorVoucher/VendorVoucher.dart';
import 'VendorProduct/Product.dart';
import 'ViewOrder.dart';

class VendorMainPage extends StatefulWidget {
  const VendorMainPage({super.key});

  @override
  State<VendorMainPage> createState() => _VendorMainPageState();
}

class _VendorMainPageState extends State<VendorMainPage> {
  double balance = 888.00; // Initial balance
  bool showBalance = true; // Toggle for balance visibility

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部 Log Out + 余额 + 头像
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 左侧 Log Out + Balance
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 108,
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                showBalance
                                    ? 'RM ${balance.toStringAsFixed(2)}'
                                    : 'RM ****',
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showBalance ? Icons.visibility : Icons
                                      .visibility_off,
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

                      // 右侧用户头像图标按钮
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          // Remove default padding
                          backgroundColor: Colors.transparent,
                          // Make button background transparent
                          shadowColor: Colors.transparent,
                          // Remove shadow
                          shape: CircleBorder(),
                          // Circular shape
                          elevation: 0, // Remove elevation
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VendorProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/image/Profile_icon.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Top up & Transaction history 行
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top up button with white border
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25), // Elliptical shape
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 2,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VendorTopUpPage()),
                          );
                        },
                        child: const Text(
                          '+ Top up',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Transaction history text button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (
                                context) => const VendorTransactionHistoryPage()),
                          );
                        },
                        child: const Text(
                          'Transaction history >',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.black),
                  const SizedBox(height: 30),

                  // 主菜单图标 Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      padding: const EdgeInsets.all(20),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildMenuButton(
                            'QR code', 'assets/image/QR_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => VendorQRPage()));
                        }),
                        _buildMenuButton(
                            'Create Voucher', 'assets/image/Voucher_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => VendorCreateVoucherPage()));
                        }),
                        _buildMenuButton(
                            'View Order', 'assets/image/Order_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => VendorViewOrderPage()));
                        }),
                        _buildMenuButton(
                            'Product', 'assets/image/Product_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => VendorProductPage()));
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 110,
              height: 110,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
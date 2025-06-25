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
  double balance = 888.00;
  bool showBalance = true;

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
                      // 左侧 Logout 和余额
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
                                showBalance
                                    ? 'RM ${balance.toStringAsFixed(2)}'
                                    : 'RM ****',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.08,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showBalance
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                      // 头像按钮
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VendorProfilePage()),
                          );
                        },
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/image/Profile_icon.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
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
                  // Grid 菜单
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
                        }, screenWidth),
                        _buildMenuButton('Create Voucher', 'assets/image/Voucher_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorVoucherPage()));
                        }, screenWidth),
                        _buildMenuButton('View Order', 'assets/image/Order_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorViewOrderPage()));
                        }, screenWidth),
                        _buildMenuButton('Product', 'assets/image/Product_icon.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VendorProductPage()));
                        }, screenWidth),
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

  Widget _buildMenuButton(String title, String imagePath, VoidCallback onTap, double screenWidth) {
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

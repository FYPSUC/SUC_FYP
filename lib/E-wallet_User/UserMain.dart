import 'package:flutter/material.dart';
import 'package:suc_fyp/main.dart';
import 'QR/QR.dart';
import 'UserProfile.dart';
import 'TopUp.dart';
import 'TransactionHistory.dart';
import '../Clinic_User/Clinic.dart';
import '../Order_User/Order.dart';
import 'Voucher.dart';
import '../Order_User/OrderPurchase.dart'; // 导入 OrderPurchase 页面（**新增**）
import 'package:suc_fyp/Order_User/models.dart' as models; // 导入模型（**新增**）

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
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
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
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
                                Container(width: 108, height: 2, color: Colors.black),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                showBalance ? 'RM ${balance.toStringAsFixed(2)}' : 'RM ****',
                                style: const TextStyle(
                                  fontSize: 40,
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
                          );
                        },
                        child: Container(
                          width: 110,
                          height: 110,
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
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 2,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserTopUpPage()),
                          );
                        },
                        child: const Text(
                          '+ Top up',
                          style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserTransactionHistoryPage()),
                          );
                        },
                        child: const Text(
                          'Transaction history >',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.black),
                  const SizedBox(height: 30),

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
                                  // ⚠️ 示例用途: 选择优惠券后跳转到订单页面
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderSummaryPage(
                                        selectedItems: {
                                          models.MenuItem(name: 'Example Item', price: 6.0, image: 'assets/image/example.png',): 1
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
            Image.asset(imagePath, width: 110, height: 110),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'QRScanPayment.dart';

class UserQRScanPage extends StatelessWidget {
  const UserQRScanPage({super.key});

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
                // 顶部返回按钮区域
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
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

                // 内容区域
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 提示文本
                        Text(
                          "Scan QR code",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 修改后的二维码按钮容器
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: InkWell( // 使用InkWell添加点击效果
                            onTap: () {
                              // 点击后跳转到支付页面
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserQRScanPaymentPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16), // 圆角效果
                            child: Container(
                              padding: const EdgeInsets.all(8), // 增加内边距使点击区域更大
                              child: Image.asset(
                                'assets/image/QRScan.png',
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
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

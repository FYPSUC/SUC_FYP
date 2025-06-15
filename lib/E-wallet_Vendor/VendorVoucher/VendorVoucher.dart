import 'package:flutter/material.dart';
import '../VendorMain.dart';

class VendorCreateVoucherPage extends StatefulWidget {
  const VendorCreateVoucherPage({super.key});

  @override
  _VendorCreateVoucherPageState createState() => _VendorCreateVoucherPageState();
}

class _VendorCreateVoucherPageState extends State<VendorCreateVoucherPage> {
  final List<Map<String, dynamic>> vouchers = [
    {
      'id': '1',
      'amount': 'RM 5 Off',
      'expiry': 'Use before 30/12',
      'claimed': 18,
      'used': 8,
      'unused': 10,
    },
    {
      'id': '2',
      'amount': 'RM 10 Off',
      'expiry': 'Use before 15/11',
      'claimed': 12,
      'used': 5,
      'unused': 7,
    },
  ];

  void _deleteVoucher(String id) {
    setState(() {
      vouchers.removeWhere((voucher) => voucher['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voucher deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  // 顶部返回按钮
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VendorMainPage()),
                        );
                      },
                      child: Row(
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 标题居中并下移
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Voucher List',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 优惠券列表
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: vouchers.length,
                      itemBuilder: (context, index) {
                        final voucher = vouchers[index];
                        return _buildVoucherCard(
                          amount: voucher['amount'],
                          expiry: voucher['expiry'],
                          claimed: voucher['claimed'],
                          used: voucher['used'],
                          unused: voucher['unused'],
                          onDelete: () => _deleteVoucher(voucher['id']),
                        );
                      },
                    ),
                  ),

                  // 创建新优惠券按钮
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade800.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            // 创建新优惠券逻辑
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Create New Voucher',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  // 美观的优惠券卡片组件
  Widget _buildVoucherCard({
    required String amount,
    required String expiry,
    required int claimed,
    required int used,
    required int unused,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFE3F2FD)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // 左侧优惠券图标
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/image/Voucher_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 右侧信息区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 优惠券金额
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 有效期
                  Text(
                    expiry,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 统计信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBadge('Claimed', claimed, Colors.blue),
                      _buildStatBadge('Used', used, Colors.green),
                      _buildStatBadge('Unused', unused, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // 操作按钮 - 修改文字颜色为黑色
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 编辑按钮 - 文字颜色改为黑色
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const VendorVoucherDetailPage(),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 18, color: Colors.black), // 图标颜色改为黑色
                            const SizedBox(width: 5),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // 文字颜色改为黑色
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 删除按钮 - 文字颜色改为黑色
                      ElevatedButton(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.black), // 图标颜色改为黑色
                            const SizedBox(width: 5),
                            Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // 文字颜色改为黑色
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 统计徽章组件
  Widget _buildStatBadge(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
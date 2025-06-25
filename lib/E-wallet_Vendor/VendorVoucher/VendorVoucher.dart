import 'package:flutter/material.dart';
import '../VendorMain.dart';
import 'VendorVoucherDetail.dart';
import 'VendorCreateVoucher.dart';

class VendorVoucherPage extends StatefulWidget {
  const VendorVoucherPage({super.key});

  @override
  _VendorVoucherPageState createState() => _VendorVoucherPageState();
}

class _VendorVoucherPageState extends State<VendorVoucherPage> {
  final List<Map<String, dynamic>> vouchers = [
    {
      'id': '1',
      'amount': 'RM 5 Off',
      'expiry': 'Use before 30/12',
      'claimed': 18,
      'used': 8,
      'unused': 10,
      'name': 'RM 5 Off',
      'discount': '5.0',
      'date': '30/12',
    },
    {
      'id': '2',
      'amount': 'RM 10 Off',
      'expiry': 'Use before 15/11',
      'claimed': 12,
      'used': 5,
      'unused': 7,
      'name': 'RM 10 Off',
      'discount': '10.0',
      'date': '15/11',
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

  void _updateVoucher(Map<String, dynamic> updatedVoucher) {
    setState(() {
      final index = vouchers.indexWhere((v) => v['id'] == updatedVoucher['id']);
      if (index != -1) {
        vouchers[index] = {
          ...vouchers[index],
          'name': updatedVoucher['name'],
          'discount': updatedVoucher['discount'],
          'date': updatedVoucher['date'],
          'amount': 'RM ${updatedVoucher['discount']} Off',
          'expiry': 'Use before ${updatedVoucher['date']}',
        };
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voucher updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VendorMainPage()),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/image/BackButton.jpg',
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: Text(
                      'Voucher List',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: vouchers.length,
                      itemBuilder: (context, index) {
                        final voucher = vouchers[index];
                        return _buildVoucherCard(
                          context,
                          screenWidth,
                          voucher: voucher,
                          onDelete: () => _deleteVoucher(voucher['id']),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0.03,
                      top: screenHeight * 0.02,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VendorCreateVoucherPage(),
                            ),
                          ).then((voucherData) {
                            if (voucherData != null) {
                              setState(() {
                                vouchers.add({
                                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                  'amount': voucherData['name'],
                                  'expiry': 'Use before ${voucherData['date']}',
                                  'claimed': 0,
                                  'used': 0,
                                  'unused': 0,
                                  'name': voucherData['name'],
                                  'discount': voucherData['amount'],
                                  'date': voucherData['date'],
                                });
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
                          ),
                        ),
                        child: Text(
                          'Create New Voucher',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

  Widget _buildVoucherCard(BuildContext context, double screenWidth, {
    required Map<String, dynamic> voucher,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.06),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFE3F2FD)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            margin: EdgeInsets.only(right: screenWidth * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              image: const DecorationImage(
                image: AssetImage('assets/image/Voucher_icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher['amount'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.015),
                Text(
                  voucher['expiry'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBadge('Claimed', voucher['claimed'], Colors.blue, screenWidth),
                    _buildStatBadge('Used', voucher['used'], Colors.green, screenWidth),
                    _buildStatBadge('Unused', voucher['unused'], Colors.orange, screenWidth),
                  ],
                ),
                SizedBox(height: screenWidth * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _actionButton(
                      label: 'Edit',
                      icon: Icons.edit,
                      color: Colors.blue,
                      screenWidth: screenWidth,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorVoucherDetailPage(
                              voucherId: voucher['id'],
                              voucherName: voucher['name'],
                              discountAmount: voucher['discount'],
                              expiredDate: voucher['date'],
                              onUpdate: _updateVoucher,
                            ),
                          ),
                        );
                      },
                    ),
                    _actionButton(
                      label: 'Delete',
                      icon: Icons.delete,
                      color: Colors.red,
                      screenWidth: screenWidth,
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, int value, Color color, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.015,
      ),
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
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: screenWidth * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required double screenWidth,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.025,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.025),
        ),
        elevation: 3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: screenWidth * 0.045, color: Colors.black),
          SizedBox(width: screenWidth * 0.015),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

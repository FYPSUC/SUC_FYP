import 'package:flutter/material.dart';
import 'package:suc_fyp/E-wallet_User/Voucher.dart'; // 导入Voucher页面
import 'package:suc_fyp/Order_User/OrderStatusPage.dart';
import 'models.dart' as models; // 使用别名导入，避免冲突
import 'package:suc_fyp/Order_User/models.dart' show Voucher; // 直接导入Voucher类

class OrderSummaryPage extends StatefulWidget {
  final Map<models.MenuItem, int> selectedItems;

  const OrderSummaryPage({super.key, required this.selectedItems});

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  Voucher? selectedVoucher; // 使用明确导入的Voucher类型

  double get subtotal {
    double total = 0;
    widget.selectedItems.forEach((item, quantity) {
      total += item.price * quantity;
    });
    return total;
  }

  double get discount => selectedVoucher?.discount ?? 0.0;
  double get totalPrice => (subtotal - discount).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/BackButton.jpg',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
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
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order summary',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.selectedItems.length,
                                itemBuilder: (context, index) {
                                  final item = widget.selectedItems.keys.elementAt(index);
                                  final quantity = widget.selectedItems[item]!;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$quantity x ${item.name}',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'RM ${(item.price * quantity).toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: screenWidth * 0.05),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Divider(color: Colors.black, thickness: 2),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Subtotal', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                                  Text('RM ${subtotal.toStringAsFixed(2)}', style: TextStyle(fontSize: screenWidth * 0.05)),
                                ],
                              ),
                              if (selectedVoucher != null) ...[
                                SizedBox(height: screenHeight * 0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Voucher (${selectedVoucher!.code})',
                                      style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '- RM ${discount.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total', style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold)),
                                  Text('RM ${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserVoucherPage(
                          onVoucherSelected: (voucher) {
                            setState(() => selectedVoucher = voucher);
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedVoucher != null
                              ? 'Voucher: ${selectedVoucher!.code}'
                              : 'Use voucher',
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                        Icon(Icons.arrow_forward_ios, size: screenWidth * 0.06),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderStatusPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
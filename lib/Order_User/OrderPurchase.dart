import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/E-wallet_User/Voucher.dart';
import 'package:suc_fyp/Order_User/OrderStatusPage.dart';
import 'models.dart' as models;
import 'package:suc_fyp/Order_User/models.dart' show Voucher;
import 'package:suc_fyp/login_system/api_service.dart';

class OrderSummaryPage extends StatefulWidget {
  final Map<models.MenuItem, int> selectedItems;
  final String vendorUID;

  const OrderSummaryPage({
    super.key,
    required this.selectedItems,
    required this.vendorUID,
  });

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  Voucher? selectedVoucher;

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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '$quantity x ${item.name}',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.03),
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
                                      'Voucher (${selectedVoucher!.name})',
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

                          vendorUID: widget.vendorUID, // ✅ 传入当前商家的 UID
                          onVoucherSelected: (voucher) {
                            setState(() => selectedVoucher = voucher);
                            print("🧾 Selected Voucher: ${selectedVoucher?.name}");
                            print("🧾 Voucher Discount: ${selectedVoucher?.discount.runtimeType} → ${selectedVoucher?.discount}");
                            print("🧾 Total Price: $totalPrice");

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
                              ? 'Voucher: ${selectedVoucher!.name}'
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
                      _showPinDialogAndPlaceOrder();
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
  Future<void> _showPinDialogAndPlaceOrder() async {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController _pinController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData = await ApiService.getUserByUID(user.uid);
    final correctPin = userData['user']['SixDigitPassword'];

    final balanceString = userData['user']['balance']?.toString() ?? '0';
    final currentBalance = double.tryParse(balanceString) ?? 0.0;

    if (!mounted) return;
    if (currentBalance < totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Enter 6-digit PIN'),
          content: TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '******',
              counterText: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final enteredPin = _pinController.text;
                if (enteredPin != correctPin) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Incorrect PIN')),
                  );
                  return;
                }

                // ✅ 第一步：创建订单，拿到 orderId
                final items = widget.selectedItems.entries.map((entry) {
                  final item = entry.key;
                  final quantity = entry.value;
                  return {
                    "product_id": item.id,
                    "quantity": quantity,
                    "unit_price": item.price,
                  };
                }).toList();

                final orderResult = await ApiService.placeOrder(
                  firebaseUID: user.uid,
                  vendorUID: widget.vendorUID,
                  total: totalPrice,
                  voucherID: selectedVoucher?.id.toString(),
                  items: items,
                );

                if (!mounted) return;

                if (orderResult['success'] != true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order failed")),
                  );
                  Navigator.pop(dialogContext, false);
                  return;
                }

                // ✅ 第二步：获取 orderId
                int orderId = orderResult['order_id'];

                // ✅ 第三步：执行转账
                final transferResult = await ApiService.transferFunds(
                  SenderID: user.uid,
                  ReceiverID: widget.vendorUID,
                  Amount: totalPrice.toStringAsFixed(2),
                  SixDigitPassword: enteredPin,
                  orderId: orderId,
                );

                if (!mounted) return;

                if (!transferResult['success']) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(transferResult['message'] ?? 'Transaction failed')),
                  );
                  Navigator.pop(dialogContext, false);
                  return;
                }
// ✅ 第四步：标记 Voucher 已使用（如果有选择）
                if (selectedVoucher != null) {
                  await ApiService.markVoucherAsUsed(
                    voucherID: selectedVoucher!.id,
                    firebaseUID: user.uid,
                    transactionID: transferResult['transaction_id'].toString(),
                  );
                }

                // ✅ 一切成功，跳转状态页
                Navigator.pop(dialogContext, true);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderStatusPage(orderId: orderId),
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


}

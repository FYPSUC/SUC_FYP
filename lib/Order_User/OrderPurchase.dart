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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/BackButton.jpg',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order summary',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
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
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$quantity x ${item.name}',
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'RM ${(item.price * quantity).toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Divider(color: Colors.black, thickness: 2),
                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Subtotal',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'RM ${subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              if (selectedVoucher != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Voucher (${selectedVoucher!.code})',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '- RM ${discount.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 20, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'RM ${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserVoucherPage(
                          onVoucherSelected: (Voucher voucher) {
                            setState(() {
                              selectedVoucher = voucher;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                          style: const TextStyle(fontSize: 20),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 24),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
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
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
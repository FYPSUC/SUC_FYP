import 'package:flutter/material.dart';

// 订单项模型 - 移到顶层
class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class VendorViewOrderPage extends StatefulWidget {
  const VendorViewOrderPage({super.key});

  @override
  State<VendorViewOrderPage> createState() => _VendorViewOrderPageState();
}

class _VendorViewOrderPageState extends State<VendorViewOrderPage> {
  bool _order1Visible = true;
  bool _order1Received = false;
  bool _order2Visible = true;
  bool _order2Received = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 返回按钮
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
                const SizedBox(height: 30),

                // 页面标题
                const Center(
                  child: Text(
                    'View Orders',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 第一个订单收据（条件渲染）
                if (_order1Visible) ...[
                  _buildReceiptCard(
                    orderNumber: 1,
                    items: [
                      OrderItem(name: 'Pearl milk tea', quantity: 1, price: 8.0),
                    ],
                    voucherDiscount: 5.0,
                    isReceived: _order1Received,
                    onReceive: () {
                      setState(() {
                        if (!_order1Received) {
                          _order1Received = true;
                        } else {
                          _order1Visible = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                ],

                // 第二个订单收据（条件渲染）
                if (_order2Visible) ...[
                  _buildReceiptCard(
                    orderNumber: 2,
                    items: [
                      OrderItem(name: 'Garden milk tea', quantity: 2, price: 5.0),
                    ],
                    voucherDiscount: 5.0,
                    isReceived: _order2Received,
                    onReceive: () {
                      setState(() {
                        if (!_order2Received) {
                          _order2Received = true;
                        } else {
                          _order2Visible = false;
                        }
                      });
                    },
                  ),
                ],

                // 当没有订单时的提示
                if (!_order1Visible && !_order2Visible) ...[
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.green[700],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'All orders completed!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No pending orders',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建收据卡片
  Widget _buildReceiptCard({
    required int orderNumber,
    required List<OrderItem> items,
    required double voucherDiscount,
    required bool isReceived,
    required VoidCallback onReceive,
  }) {
    double subtotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double total = subtotal - voucherDiscount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 收据顶部装饰
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 订单标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #$orderNumber',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isReceived ? Colors.blue[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isReceived ? 'Processing' : 'New Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isReceived ? Colors.blue[700] : Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // 订单项目
                const Divider(),
                ...items.map((item) => _buildOrderItemRow(item)).toList(),
                const Divider(),
                const SizedBox(height: 10),

                // 费用明细
                _buildCostDetailRow('Subtotal', 'RM ${subtotal.toStringAsFixed(1)}'),
                _buildCostDetailRow('Voucher used', '- RM ${voucherDiscount.toStringAsFixed(1)}',
                    isDiscount: true),
                const SizedBox(height: 10),
                _buildCostDetailRow('TOTAL', 'RM ${total.toStringAsFixed(1)}',
                    isTotal: true),
                const SizedBox(height: 25),

                // 接收/完成订单按钮
                ElevatedButton(
                  onPressed: onReceive,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isReceived ? Colors.blue : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        isReceived ? 'COMPLETE ORDER' : 'RECEIVE ORDER',
                        style: const TextStyle(
                          fontSize: 22,
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
        ],
      ),
    );
  }

  // 构建订单项行
  Widget _buildOrderItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    item.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            'RM ${(item.price * item.quantity).toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 构建费用明细行
  Widget _buildCostDetailRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 24 : 20,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 24 : 20,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
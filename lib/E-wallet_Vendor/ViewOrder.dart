import 'package:flutter/material.dart';

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Text(
                    'View Orders',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                if (_order1Visible)
                  _buildReceiptCard(
                    context,
                    orderNumber: 1,
                    items: [OrderItem(name: 'Pearl milk tea', quantity: 1, price: 8.0)],
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
                SizedBox(height: screenHeight * 0.02),
                if (_order2Visible)
                  _buildReceiptCard(
                    context,
                    orderNumber: 2,
                    items: [OrderItem(name: 'Garden milk tea', quantity: 2, price: 5.0)],
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
                if (!_order1Visible && !_order2Visible)
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.1),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: screenWidth * 0.2, color: Colors.green[700]),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'All orders completed!',
                            style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'No pending orders',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.grey,
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

  Widget _buildReceiptCard(BuildContext context,
      {required int orderNumber,
        required List<OrderItem> items,
        required double voucherDiscount,
        required bool isReceived,
        required VoidCallback onReceive}) {
    final screenWidth = MediaQuery.of(context).size.width;
    double subtotal = items.fold(0, (sum, item) => sum + item.price * item.quantity);
    double total = subtotal - voucherDiscount;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #$orderNumber',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, vertical: screenWidth * 0.01),
                  decoration: BoxDecoration(
                    color: isReceived ? Colors.blue[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isReceived ? 'Processing' : 'New Order',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isReceived ? Colors.blue[700] : Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            ...items.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.quantity}x ${item.name}',
                      style: TextStyle(
                          fontSize: screenWidth * 0.045, fontWeight: FontWeight.w500)),
                  Text('RM ${(item.price * item.quantity).toStringAsFixed(1)}',
                      style: TextStyle(
                          fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
                ],
              ),
            )),
            const Divider(),
            _buildCostRow(context, 'Subtotal', subtotal, isTotal: false),
            _buildCostRow(context, 'Voucher used', -voucherDiscount, isDiscount: true),
            _buildCostRow(context, 'TOTAL', total, isTotal: true),
            SizedBox(height: screenWidth * 0.04),
            ElevatedButton(
              onPressed: onReceive,
              style: ElevatedButton.styleFrom(
                backgroundColor: isReceived ? Colors.blue : Colors.green,
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    isReceived ? 'COMPLETE ORDER' : 'RECEIVE ORDER',
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(BuildContext context, String label, double value,
      {bool isTotal = false, bool isDiscount = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? screenWidth * 0.06 : screenWidth * 0.045,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : Colors.black,
            ),
          ),
          Text(
            'RM ${value.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: isTotal ? screenWidth * 0.06 : screenWidth * 0.045,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class VendorViewOrderPage extends StatefulWidget {
  const VendorViewOrderPage({super.key});

  @override
  State<VendorViewOrderPage> createState() => _VendorViewOrderPageState();
}

class _VendorViewOrderPageState extends State<VendorViewOrderPage> {
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final orders = await ApiService.getVendorOrders(uid);
      setState(() {
        _orders = orders;
        _loading = false;
      });
    }
  }

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
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _orders.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          )
              : SingleChildScrollView(
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
                ..._orders.map((order) => _buildReceiptCard(context, order)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard(BuildContext context, Map<String, dynamic> order) {
    final screenWidth = MediaQuery.of(context).size.width;
    final items = List<Map<String, dynamic>>.from(order['items']);
    double subtotal = items.fold(
        0, (sum, item) => sum + item['Quantity'] * item['UnitPrice']);
    double voucherDiscount = 5.0; // TODO: 可改为从后端动态获取
    double total = subtotal - voucherDiscount;

    String currentStatus = order['status'] ?? 'pending';
    bool isPending = currentStatus == 'pending';
    bool isPreparing = currentStatus == 'preparing';
    bool isCompleted = currentStatus == 'completed';

    String displayStatus = currentStatus[0].toUpperCase() + currentStatus.substring(1);

    String nextStatus = '';
    String buttonText = '';
    Color buttonColor = Colors.grey;

    if (isPending) {
      nextStatus = 'preparing';
      buttonText = 'RECEIVE ORDER';
      buttonColor = Colors.green;
    } else if (isPreparing) {
      nextStatus = 'completed';
      buttonText = 'COMPLETE ORDER';
      buttonColor = Colors.blue;
    }

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Order ID & Status Badge ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order['orderId']}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, vertical: screenWidth * 0.01),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.grey[300]
                        : isPreparing
                        ? Colors.blue[50]
                        : Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    displayStatus,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? Colors.grey[700]
                          : isPreparing
                          ? Colors.blue[700]
                          : Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),

            const Divider(),

            // --- Order Items ---
            ...items.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${item['Quantity']}x ${item['ProductName']}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'RM ${(item['UnitPrice'] * item['Quantity']).toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            )),

            const Divider(),

            _buildCostRow(context, 'Subtotal', subtotal, isTotal: false),
            _buildCostRow(context, 'Voucher used', -voucherDiscount, isDiscount: true),
            _buildCostRow(context, 'TOTAL', total, isTotal: true),

            SizedBox(height: screenWidth * 0.04),

            // --- Action Button ---
            if (!isCompleted)
              ElevatedButton(
                onPressed: () async {
                  final success = await ApiService.updateOrderStatus(
                    order['orderId'],
                    nextStatus,
                  );

                  if (success) {
                    setState(() {
                      order['status'] = nextStatus;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update order status')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      buttonText,
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

import 'package:flutter/material.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class VendorOrderHistoryDetailPage extends StatefulWidget {
  final int orderId;
  const VendorOrderHistoryDetailPage({super.key, required this.orderId});

  @override
  State<VendorOrderHistoryDetailPage> createState() => _VendorOrderHistoryDetailPageState();
}

class _VendorOrderHistoryDetailPageState extends State<VendorOrderHistoryDetailPage> {
  Map<String, dynamic>? orderDetail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    final response = await ApiService.getOrderById(widget.orderId);
    print("API response: $response");
    if (response['success']) {
      setState(() {
        orderDetail = response['order'];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : orderDetail == null
                ? const Center(child: Text("Failed to load order details"))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Status: ${orderDetail!['status']}",
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  "Total: RM${orderDetail!['total'].toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(thickness: 2),
                Text(
                  "Items:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
                ...List<Map<String, dynamic>>.from(orderDetail!['items']).map(
                      (item) => ListTile(
                    title: Text(
                      "${item['Quantity']}x ${item['ProductName']}",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                    trailing: Text(
                      "RM ${(item['UnitPrice'] * item['Quantity']).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: screenWidth * 0.045),
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

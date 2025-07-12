import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/models/transaction_model.dart';
import 'package:suc_fyp/E-wallet_Vendor/VendorOrderHistoryDetailPage.dart'; // 假设你已有这个页面

class VendorTransactionHistoryPage extends StatefulWidget {
  const VendorTransactionHistoryPage({super.key});

  @override
  State<VendorTransactionHistoryPage> createState() => _VendorTransactionHistoryPageState();
}

class _VendorTransactionHistoryPageState extends State<VendorTransactionHistoryPage> {
  List<UserTransaction> transactions = [];
  double totalIncome = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final response = await ApiService.getVendorTransactions(user.uid);
      if (response['success']) {
        final loadedTx = (response['transactions'] as List)
            .map((tx) => UserTransaction.fromJson(tx))
            .toList();

        double income = 0;
        for (var tx in loadedTx) {
          income += tx.amount;
        }

        setState(() {
          transactions = loadedTx;
          totalIncome = income;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/image/BackButton.jpg',
                        width: screenWidth * 0.1,
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
                SizedBox(height: screenHeight * 0.015),

                // Income summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAmountBox('Total Income', 'RM${totalIncome.toStringAsFixed(2)}', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Chart placeholder
                Center(
                  child: Image.asset(
                    'assets/image/VendorTransaction_Graph.png',
                    width: screenWidth * 0.9,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Text(
                  'Transaction history',
                  style: TextStyle(
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Expanded(
                  child: transactions.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionItem(transactions[index], screenWidth);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountBox(String label, String value, double screenWidth) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(UserTransaction tx, double screenWidth) {
    return GestureDetector(
      onTap: () {
        if (tx.orderId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorOrderHistoryDetailPage(orderId: tx.orderId!),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tx.title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '+RM${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

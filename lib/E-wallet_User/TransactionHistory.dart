import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/Order_User/OrderStatusPage.dart';
import 'package:suc_fyp/models/transaction_model.dart'; // 👈 你刚刚创建的 model

class UserTransactionHistoryPage extends StatefulWidget {
  const UserTransactionHistoryPage({super.key});

  @override
  State<UserTransactionHistoryPage> createState() => _UserTransactionHistoryPageState();
}

class _UserTransactionHistoryPageState extends State<UserTransactionHistoryPage> {
  List<UserTransaction> transactions = [];
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final response = await ApiService.getUserTransactions(user.uid);
      if (response['success']) {
        final loadedTx = (response['transactions'] as List)
            .map((tx) => UserTransaction.fromJson(tx))
            .toList();

        // 计算总收入与支出
        double income = 0;
        double expense = 0;
        for (var tx in loadedTx) {
          if (tx.amount > 0) {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }

        setState(() {
          transactions = loadedTx;
          totalIncome = income;
          totalExpense = -expense; // 支出是负数，需要转正
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
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                ),
                SizedBox(height: screenHeight * 0.015),

                // Amount & Expense Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAmountBox('Amount', 'RM${totalIncome.toStringAsFixed(2)}', screenWidth),
                    _buildAmountBox('Expense', 'RM${totalExpense.toStringAsFixed(2)}', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Chart (占位图)
                Center(
                  child: Image.asset(
                    'assets/image/Transaction_Graph.png',
                    width: screenWidth * 0.9,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Text(
                  'Transaction history',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Scrollable list
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionItem(transactions[index], screenWidth, context);
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

  Widget _buildTransactionItem(UserTransaction tx, double screenWidth, BuildContext context) {
    final isIncomeType = tx.type == 'topup' || tx.type == 'transfer_in' || tx.type == 'order_refund';

    return GestureDetector(
      onTap: () {
        if (tx.orderId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderStatusPage(orderId: tx.orderId!),
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
                  '${isIncomeType ? '+' : '-'}RM${tx.amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: isIncomeType ? Colors.green : Colors.red,
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


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/models/transaction_model.dart';
import 'package:suc_fyp/E-wallet_Vendor/VendorOrderHistoryDetailPage.dart';
import 'package:suc_fyp/prediction_data.dart';

class VendorTransactionHistoryPage extends StatefulWidget {
  const VendorTransactionHistoryPage({super.key});

  @override
  State<VendorTransactionHistoryPage> createState() => _VendorTransactionHistoryPageState();
}

class _VendorTransactionHistoryPageState extends State<VendorTransactionHistoryPage> {
  List<UserTransaction> transactions = [];
  double totalIncome = 0;
  double topupIncome = 0;
  double orderIncome = 0;
  bool showPredictionDetail = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<List<PredictionData>> _fetchPredictionData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final result = await ApiService.fetchPredictions(uid);
        print("📊 Prediction fetched: $result");
        return result;
      } catch (e) {
        print("❌ Error fetching prediction: $e");
        return [];
      }
    }
    return [];
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
        double topup = 0;
        double order = 0;

        for (var tx in loadedTx) {
          income += tx.amount;
          if (tx.type == 'topup') {
            topup += tx.amount;
          } else if (tx.type == 'order') {
            order += tx.amount;
          }
        }

        setState(() {
          transactions = loadedTx;
          totalIncome = income;
          topupIncome = topup;
          orderIncome = order;
        });
      }
    }
  }

  Widget _buildPieChart(double width) {
    final total = topupIncome + orderIncome;

    if (total == 0) {
      return const Text("No income data to show.");
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: orderIncome,
              title: 'Orders\n${(orderIncome / total * 100).toStringAsFixed(1)}%',
              color: Colors.green,
              radius: 65,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: topupIncome,
              title: 'Top-up\n${(topupIncome / total * 100).toStringAsFixed(1)}%',
              color: Colors.blue,
              radius: 65,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
          sectionsSpace: 4,
          centerSpaceRadius: 30,
        ),
      ),
    );
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAmountBox('Total Income', 'RM${totalIncome.toStringAsFixed(2)}', screenWidth),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPieChart(screenWidth * 0.9),

                              SizedBox(height: screenHeight * 0.01),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPredictionDetail = !showPredictionDetail;
                                  });
                                },
                                child: Text(
                                  showPredictionDetail ? 'Hide Details ▲' : 'Show Details ▼',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (showPredictionDetail)
                                Container(
                                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                                  padding: EdgeInsets.all(20),
                                  width: screenWidth * 0.95,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hourly Predicted Income',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.055,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      _buildPredictionChart(screenWidth*0.25, screenHeight * 0.45),
                                    ],
                                  ),
                                ),
                            ],
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
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            return _buildTransactionItem(transactions[index], screenWidth);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionChart(double screenWidth, double screenHeight) {
    return FutureBuilder<List<PredictionData>>(
      future: _fetchPredictionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No prediction data available");
        }

        final data = snapshot.data!;
        final spots = data.map((d) => FlSpot(d.hour.toDouble(), d.amount)).toList();

        return SizedBox(
          height: screenHeight,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 140,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 3,
                    getTitlesWidget: (value, meta) {
                      final hour = value.toInt();
                      return Text('$hour:00', style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      return Text('RM${value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: 23,
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: spots,
                  barWidth: 3,
                  color: Colors.green,
                  belowBarData: BarAreaData(show: false),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        );
      },
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

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

  // 新增：预测数据
  double? predictedTotalIncome;
  String? predictedDate;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadPrediction(); // 加载下一天总收入预测
  }

  // new: 从后端获取 total prediction
  Future<void> _loadPrediction() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final data = await ApiService.fetchPredictions(uid); // 返回 { total, date }
      setState(() {
        predictedTotalIncome = data['total'] as double;
        predictedDate = data['date'] as String?;
      });
      print("📅 Predicted total for $predictedDate: $predictedTotalIncome");
    } catch (e) {
      print("❌ Error fetching prediction: $e");
      setState(() {
        predictedTotalIncome = null;
        predictedDate = null;
      });
    }
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
                                  constraints: BoxConstraints(
                                    minHeight: screenHeight * 0.45, // 白框整体更高
                                  ),
                                  margin: EdgeInsets.only(top: screenHeight * 0.005),
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
                                        'Next day predicted total income',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.055,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),
                                      _buildPredictionLineChart(screenWidth * 0.9, screenHeight * 0.35),
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

  Widget _buildPredictionLineChart(double width, double height) {
    if (predictedTotalIncome == null || transactions.isEmpty) {
      return const Text("No prediction data available");
    }

    // 1. 构造历史数据（按日期排序）
    final historyData = transactions
        .map((t) => MapEntry(t.date, t.amount))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // 2. X 轴标签（过去日期 + 预测日期）
    final allDates = [
      ...historyData.map((e) => e.key),
      DateTime.parse(predictedDate!)
    ];

    // 3. LineChartSpots for history
    final historySpots = historyData.asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value.value;
      return FlSpot(index.toDouble(), amount);
    }).toList();

    // 4. LineChartSpots for prediction
    final predIndex = allDates.length - 1;
    final predictionSpots = [
      FlSpot((predIndex - 1).toDouble(), historyData.last.value), // 上一天
      FlSpot(predIndex.toDouble(), predictedTotalIncome!)         // 预测
    ];

    // 5. 最大值（给 Y 轴留空间）
    final maxY = [
      ...historyData.map((e) => e.value),
      predictedTotalIncome!
    ].reduce((a, b) => a > b ? a : b) * 1.3;

    return SizedBox(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30, // 给底部刻度预留空间
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < allDates.length) {
                    final date = allDates[index];
                    final isPred = index == predIndex;
                    return Text(
                      isPred
                          ? '${date.month}/${date.day}\n(Pred)'
                          : '${date.month}/${date.day}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isPred ? FontWeight.bold : FontWeight.normal,
                        color: isPred ? Colors.green : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 4,
                getTitlesWidget: (v, meta) =>
                    Text('RM${v.toInt()}', style: const TextStyle(fontSize: 10)),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // 历史数据（实线）
            LineChartBarData(
              spots: historySpots,
              isCurved: true,
              barWidth: 3,
              color: Colors.blue,
              dotData: FlDotData(show: true),
            ),
            // 预测数据（虚线）
            LineChartBarData(
              spots: predictionSpots,
              isCurved: false,
              barWidth: 2,
              color: Colors.green,
              dashArray: [5, 5], // 虚线
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.green,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
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

import 'package:flutter/material.dart';

class VendorTransactionHistoryPage extends StatefulWidget {
  const VendorTransactionHistoryPage({super.key});

  @override
  State<VendorTransactionHistoryPage> createState() =>
      _VendorTransactionHistoryPageState();
}

class _VendorTransactionHistoryPageState
    extends State<VendorTransactionHistoryPage> {
  bool _showDetailedGraph = false;

  void _toggleGraphView() {
    setState(() {
      _showDetailedGraph = !_showDetailedGraph;
    });
  }

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

                // 收入与支出概览
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAmountCard('Income', 'RM38.00'),
                    _buildAmountCard('Expense', 'RM88.00'),
                  ],
                ),
                const SizedBox(height: 30),

                // 图表区域 - 根据状态显示不同的图表组合
                _showDetailedGraph
                    ? Column(
                  children: [
                    // 双图表布局（上下排列）
                    Image.asset(
                      'assets/image/VendorTransaction_Graph.png',
                      width: 350,
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/image/VendorTransaction_Graph2.png',
                      width: 350,
                    ),
                    const SizedBox(height: 15),
                    // 图表标题
                    const Center(
                      child: Text(
                        'Monthly sales of products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    // 单图表布局
                    Center(
                      child: Image.asset(
                        'assets/image/VendorTransaction_Graph.png',
                        width: 350,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 交易历史标题 + View More/Less按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction history',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _toggleGraphView,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          _showDetailedGraph ? 'View Less' : 'View More',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // 交易记录列表
                _buildTransactionItem('Top up', '+RM20.00', '24/12/2024'),
                _buildTransactionItem('StudentA', '+RM8.00', '23/12/2024'),
                _buildTransactionItem('StudentB', '+RM10.00', '21/12/2024'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 金额卡片组件
  Widget _buildAmountCard(String title, String amount) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // 交易记录项组件
  Widget _buildTransactionItem(String title, String amount, String date) {
    return Container(
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
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 25,
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
                date,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
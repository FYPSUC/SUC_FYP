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
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAmountCard('Income', 'RM38.00', screenWidth),
                    _buildAmountCard('Expense', 'RM88.00', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                _showDetailedGraph
                    ? Column(
                  children: [
                    Image.asset(
                      'assets/image/VendorTransaction_Graph.png',
                      width: screenWidth * 0.9,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Image.asset(
                      'assets/image/VendorTransaction_Graph2.png',
                      width: screenWidth * 0.9,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Text(
                        'Monthly sales of products',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                    : Center(
                  child: Image.asset(
                    'assets/image/VendorTransaction_Graph.png',
                    width: screenWidth * 0.9,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction history',
                      style: TextStyle(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _toggleGraphView,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _showDetailedGraph ? 'View Less' : 'View More',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTransactionItem('Top up', '+RM20.00', '24/12/2024', screenWidth),
                _buildTransactionItem('StudentA', '+RM8.00', '23/12/2024', screenWidth),
                _buildTransactionItem('StudentB', '+RM10.00', '21/12/2024', screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard(String title, String amount, double screenWidth) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: screenWidth * 0.025,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            amount,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
      String title, String amount, String date, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
      padding: EdgeInsets.all(screenWidth * 0.04),
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
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                amount,
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
              padding: EdgeInsets.only(top: screenWidth * 0.01),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
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

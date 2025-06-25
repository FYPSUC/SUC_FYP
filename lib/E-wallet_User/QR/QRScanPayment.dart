import 'package:flutter/material.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';

class UserQRScanPaymentPage extends StatefulWidget {
  const UserQRScanPaymentPage({super.key});

  @override
  State<UserQRScanPaymentPage> createState() => _UserQRScanPaymentPageState();
}

class _UserQRScanPaymentPageState extends State<UserQRScanPaymentPage> {
  bool showPinInput = false;
  String amount = '';
  String _rawAmount = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_handleManualInput);
  }

  @override
  void dispose() {
    _amountController.removeListener(_handleManualInput);
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleManualInput() {
    final text = _amountController.text.replaceAll(RegExp(r'\D'), '');
    if (text != _rawAmount) {
      setState(() {
        _rawAmount = text;
        _amountController.value = _amountController.value.copyWith(
          text: _formatAmount(_rawAmount),
          selection: TextSelection.collapsed(
            offset: _formatAmount(_rawAmount).length,
          ),
        );
      });
    }
  }

  String _formatAmount(String raw) {
    if (raw.isEmpty) return "0.00";
    double value = double.tryParse(raw) ?? 0;
    return value == 0 ? "0.00" : (value / 100).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/image/BackButton.jpg',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: showPinInput
                        ? buildPinInput(context, screenWidth, screenHeight)
                        : buildAmountInput(context, screenWidth, screenHeight),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAmountInput(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: [
        const Spacer(),
        Column(
          children: [
            Text(
              "Enter Amount",
              style: TextStyle(
                fontSize: screenWidth * 0.075,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RM : ',
                  style: TextStyle(
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: screenWidth * 0.065, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "0.00",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.05),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
            ),
            onPressed: () {
              setState(() {
                amount = _formatAmount(_rawAmount);
                showPinInput = true;
              });
            },
            child: Text(
              "Confirmation of transfer",
              style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPinInput(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: [
        const Spacer(),
        Column(
          children: [
            Text(
              "Enter Amount",
              style: TextStyle(
                fontSize: screenWidth * 0.075,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'RM : ${amount.isEmpty ? "0.00" : amount}',
              style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Please enter 6-Digit pin linked to account',
              style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: screenWidth * 0.6,
              child: TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenWidth * 0.07, letterSpacing: 12, color: Colors.black),
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.05),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: screenHeight * 0.02),
            ),
            onPressed: () {
              String enteredPin = _pinController.text;
              if (enteredPin.length == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSuccessPage(amount: amount),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter 6 digits')),
                );
              }
            },
            child: Text(
              "Confirm",
              style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  final String amount;

  const PaymentSuccessPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserMainPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/image/BackButton.jpg',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.12),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Payment successful',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.08),
                      Image.asset(
                        'assets/image/cash.png',
                        width: screenWidth * 0.6,
                        height: screenWidth * 0.6,
                      ),
                      Text(
                        'RM ${amount.isEmpty ? "0.00" : amount}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
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

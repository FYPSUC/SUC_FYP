import 'package:flutter/material.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';

class VendorQRScanPaymentPage extends StatefulWidget {
  final String qrData; // 这是用户 UID
  const VendorQRScanPaymentPage({super.key, required this.qrData});

  @override
  State<VendorQRScanPaymentPage> createState() => _VendorQRScanPaymentPageState();
}

class _VendorQRScanPaymentPageState extends State<VendorQRScanPaymentPage> {
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
          selection: TextSelection.collapsed(offset: _formatAmount(_rawAmount).length),
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
              style: TextStyle(fontSize: screenWidth * 0.075, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RM : ',
                  style: TextStyle(fontSize: screenWidth * 0.065, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: screenWidth * 0.065),
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
            onPressed: () {
              setState(() {
                amount = _formatAmount(_rawAmount);
                showPinInput = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
            ),
            child: Text("Confirmation of transfer",
                style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: screenWidth * 0.075, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'RM : $amount',
              style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Please enter 6-digit pin linked to your shop',
              style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: screenWidth * 0.07, letterSpacing: 12),
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.05),
          child: ElevatedButton(
            onPressed: () async {
              String enteredPin = _pinController.text;
              if (enteredPin.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter 6 digits')),
                );
                return;
              }

              final vendor = FirebaseAuth.instance.currentUser;
              if (vendor != null) {
                final response = await ApiService.getVendorByUID(vendor.uid);
                final correctPin = response['user']['SixDigitPassword']; // 注意 key 仍然是 "user"

                if (enteredPin == correctPin) {
                  final transferResult = await ApiService.transferFunds(
                    SenderID: vendor.uid,
                    ReceiverID: widget.qrData,
                    Amount: amount,
                    SixDigitPassword: enteredPin,
                  );

                  if (transferResult['success']) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSuccessPage(amount: amount),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(transferResult['message'] ?? 'Transfer failed')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect 6-digit password')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: screenHeight * 0.02),
            ),
            child: Text("Confirm",
                style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold)),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const UserMainPage()),
                    );
                  },
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
                        style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.08),
                      Image.asset(
                        'assets/image/cash.png',
                        width: screenWidth * 0.6,
                        height: screenWidth * 0.6,
                      ),
                      Text(
                        'RM $amount',
                        style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
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

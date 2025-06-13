import 'package:flutter/material.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';

class VendorQRScanPaymentPage extends StatefulWidget {
  const VendorQRScanPaymentPage({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Back Button
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
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: showPinInput
                        ? buildPinInput(context)
                        : buildAmountInput(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAmountInput(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Column(
          children: [
            Text(
              "Enter Amount",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'RM : ',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 26, color: Colors.black),
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
          padding: const EdgeInsets.only(bottom: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            ),
            onPressed: () {
              setState(() {
                amount = _formatAmount(_rawAmount);
                showPinInput = true;
              });
            },
            child: const Text(
              "Confirmation of transfer",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPinInput(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Column(
          children: [
            Text(
              "Enter Amount",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'RM : ${amount.isEmpty ? "0.00" : amount}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'Please enter 6-Digit pin linked to account',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 28, letterSpacing: 12, color: Colors.black),
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
          padding: const EdgeInsets.only(bottom: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 100, vertical: 18),
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
            child: const Text(
              "Confirm",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
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
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Payment successful',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 70),
                      Image.asset(
                        'assets/image/cash.png',
                        width: 250,
                        height: 250,
                      ),
                      Text(
                        'RM ${amount.isEmpty ? "0.00" : amount}',
                        style: const TextStyle(
                          fontSize: 35,
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

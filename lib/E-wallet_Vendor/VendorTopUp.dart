import 'package:flutter/material.dart';
import 'VendorMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class VendorTopUpPage extends StatefulWidget {
  const VendorTopUpPage({super.key});

  @override
  State<VendorTopUpPage> createState() => _VendorTopUpPageState();
}

class _VendorTopUpPageState extends State<VendorTopUpPage> {
  String _rawAmount = '';
  String? _selectedBank;
  String _enteredAmount = '';
  bool _showLimitMessage = false;

  final TextEditingController _amountController = TextEditingController();

  final List<String> _amounts = ['1', '5', '10', '25', '50', '100'];
  final List<String> _banks = [
    'Maybank',
    'CIMB',
    'Public Bank',
    'RHB',
    'Hong Leong Bank',
  ];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_handleManualInput);
  }

  @override
  void dispose() {
    _amountController.dispose();
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
    if (raw.isEmpty) return '';
    final padded = raw.padLeft(3, '0');
    final intPart = padded.substring(0, padded.length - 2);
    final decPart = padded.substring(padded.length - 2);
    return '$intPart.$decPart';
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07, vertical: screenHeight * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VendorMainPage()),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/image/BackButton.jpg',
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text('Back', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text('Top Up', style: TextStyle(fontSize: screenWidth * 0.075, fontWeight: FontWeight.bold)),
              const Divider(thickness: 2, color: Colors.black87),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: screenWidth * 0.06),
                decoration: InputDecoration(
                  prefixText: 'RM ',
                  prefixStyle: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w600),
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(fontSize: screenWidth * 0.05),
                  contentPadding: EdgeInsets.all(screenWidth * 0.04),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onChanged: (value) {
                  String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

                  if (digitsOnly.isEmpty) {
                    _amountController.text = '';
                    setState(() {
                      _enteredAmount = '';
                      _showLimitMessage = false;
                    });
                    return;
                  }

                  if (digitsOnly.length > 7) {
                    digitsOnly = digitsOnly.substring(0, 7);
                  }

                  double numericValue = double.parse(digitsOnly) / 100;
                  if (numericValue > 1000.00) {
                    numericValue = 1000.00;
                    digitsOnly = '100000';
                  }

                  String formatted = numericValue.toStringAsFixed(2);

                  _amountController
                    ..text = formatted
                    ..selection = TextSelection.collapsed(offset: formatted.length);

                  setState(() {
                    _enteredAmount = formatted;
                    _showLimitMessage = numericValue == 1000.00;
                  });
                },
              ),
              if (_showLimitMessage)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Text('Top Up is limited to 1,000', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Wrap(
                  spacing: screenWidth * 0.05,
                  runSpacing: screenHeight * 0.02,
                  children: _amounts.map((amount) {
                    return SizedBox(
                      width: screenWidth * 0.35,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _enteredAmount = amount;
                            _amountController.text = double.parse(amount).toStringAsFixed(2);
                            _amountController.selection = TextSelection.collapsed(offset: _amountController.text.length);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          side: const BorderSide(color: Colors.black, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: Text('RM $amount', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Text('Choose bank', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
                ),
                hint: Text('Select your bank', style: TextStyle(fontSize: screenWidth * 0.05)),
                value: _selectedBank,
                items: _banks.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank, style: TextStyle(fontSize: screenWidth * 0.045)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBank = newValue;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _amountController.text.isEmpty || _selectedBank == null ? null : () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? uid = prefs.getString('uid');

                    if (uid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Vendor 未登录")),
                      );
                      return;
                    }

                    double amount = double.tryParse(_enteredAmount) ?? 0.0;
                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ 金额无效")),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    bool success = await ApiService.topUp(uid, amount, 'Vendor');
                    Navigator.of(context).pop(); // 关闭 loading

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Vendor Top Up 成功")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VendorMainPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Top up 失败")),
                      );
                    }
                  },

                  child: Text('Top Up', style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'VendorMain.dart';

class VendorTopUpPage extends StatefulWidget {
  const VendorTopUpPage({super.key});

  @override
  State<VendorTopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<VendorTopUpPage> {
  String _rawAmount = ''; // 用户实际输入的原始数字字符串
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

  // 处理手动输入（模拟 TNG 金额格式）
  void _handleManualInput() {
    // 只拦截实际键盘输入的数字
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

  // 格式化为 0.00 形式
  String _formatAmount(String raw) {
    if (raw.isEmpty) return '';
    final padded = raw.padLeft(3, '0'); // 至少三个字符
    final intPart = padded.substring(0, padded.length - 2);
    final decPart = padded.substring(padded.length - 2);
    return '$intPart.$decPart';
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

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VendorMainPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Important to prevent row from expanding
                      children: [
                        Image.asset(
                          'assets/image/BackButton.jpg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8), // Add some spacing between icon and text
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
              ),
              const SizedBox(height: 30),
              const Text(
                'Top Up',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 2, color: Colors.black87),
              const SizedBox(height: 30),

              // ✅ TextField 设置为只输入数字 + 自动格式化
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 25, // 输入文字大小
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  prefixText: 'RM ',
                  prefixStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  hintText: 'Enter amount',
                  hintStyle: const TextStyle(
                    fontSize: 20, // hintText 字体大小
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.all(15),

                  // 黑色边框（未聚焦）
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // 边框颜色
                      width: 2,             // 边框粗细
                    ),
                  ),

                  // 黑色边框（聚焦时）
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2, // 聚焦时更明显
                    ),
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
                    ..selection = TextSelection.collapsed(
                      offset: formatted.length,
                    );

                  setState(() {
                    _enteredAmount = formatted;
                    _showLimitMessage = numericValue == 1000.00;
                  });
                },
              ),

              if (_showLimitMessage)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Top Up is limited to 1,000',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 30),

              Center(
                child: Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  children: _amounts.map((amount) {
                    return SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _enteredAmount = amount;
                            _amountController.text =
                                double.parse(amount).toStringAsFixed(2);
                            _amountController.selection = TextSelection.collapsed(
                              offset: _amountController.text.length,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'RM $amount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),


              const SizedBox(height: 30),
              const Divider(height: 1, color: Colors.black),
              const SizedBox(height: 30),

              const Text(
                'Choose bank',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  // 黑色边框（未聚焦）
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  // 黑色边框（聚焦时）
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
                hint: const Text(
                  'Select your bank',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                value: _selectedBank,
                items: _banks.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(
                      bank,
                      style: const TextStyle(fontSize: 17), // 可选：下拉项字体大小
                    ),
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
                  onPressed:
                  _amountController.text.isEmpty || _selectedBank == null
                      ? null
                      : () {
                    // TODO: Proceed with top-up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Top Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:suc_fyp/login_system/api_service.dart'; // 你已有的 ApiService 文件
import 'package:firebase_auth/firebase_auth.dart';

class VendorCreateVoucherPage extends StatefulWidget {
  const VendorCreateVoucherPage({super.key});

  @override
  State<VendorCreateVoucherPage> createState() => _VendorCreateVoucherPage();
}

class _VendorCreateVoucherPage extends State<VendorCreateVoucherPage> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  DateTime? _selectedDate;
  String _enteredAmount = '';
  bool _showLimitMessage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/UserMainBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenWidth * 0.05),
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
                                height: screenWidth * 0.1,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 20 * fontScale,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.08),
                        Center(
                          child: Text(
                            'Create Voucher',
                            style: TextStyle(
                              fontSize: 26 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  _buildInputField('Voucher Name', _nameController, fontScale),
                  SizedBox(height: screenWidth * 0.08),
                  _buildAmountField(fontScale),
                  SizedBox(height: screenWidth * 0.08),
                  _buildDateField(context, fontScale),
                  SizedBox(height: screenWidth * 0.1),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty &&
                            _enteredAmount.isNotEmpty &&
                            _selectedDate != null) {

                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) return;

                          final response = await ApiService.createVoucher(
                            firebaseUID: user.uid,
                            name: _nameController.text,
                            amount: double.parse(_enteredAmount),
                            expiredDate: _selectedDate!,
                          );

                          if (response['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Voucher created successfully')),

                            );
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to create voucher')),
                            );
                          }
                        }
                      }
                      ,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2, vertical: screenWidth * 0.045),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: Text(
                        'Publish',
                        style: TextStyle(
                          fontSize: 20 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, double fontScale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField(double fontScale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discount Amount', style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: Text('RM', style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '0.00',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    borderSide: BorderSide.none,
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
                  if (digitsOnly.length > 5) {
                    digitsOnly = digitsOnly.substring(0, 5);
                  }
                  double numericValue = double.parse(digitsOnly) / 100;
                  String formatted = numericValue.toStringAsFixed(2);
                  _amountController
                    ..text = formatted
                    ..selection = TextSelection.collapsed(offset: formatted.length);
                  setState(() {
                    _enteredAmount = formatted;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, double fontScale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Expired Date', style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                hintText: 'DD/MM',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

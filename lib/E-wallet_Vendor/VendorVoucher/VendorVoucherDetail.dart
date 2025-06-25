import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VendorVoucherDetailPage extends StatefulWidget {
  final String voucherId;
  final String voucherName;
  final String discountAmount;
  final String expiredDate;
  final Function(Map<String, dynamic> updatedVoucher) onUpdate;

  const VendorVoucherDetailPage({
    super.key,
    required this.voucherId,
    required this.voucherName,
    required this.discountAmount,
    required this.expiredDate,
    required this.onUpdate,
  });

  @override
  _VendorVoucherDetailPageState createState() => _VendorVoucherDetailPageState();
}

class _VendorVoucherDetailPageState extends State<VendorVoucherDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  DateTime? _selectedDate;
  String _enteredAmount = '';
  bool _showLimitMessage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.voucherName);
    _amountController = TextEditingController(text: widget.discountAmount);
    _enteredAmount = widget.discountAmount;
    _dateController = TextEditingController(text: widget.expiredDate);

    try {
      final dateParts = widget.expiredDate.split('/');
      if (dateParts.length == 2) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final currentYear = DateTime.now().year;
        _selectedDate = DateTime(currentYear, month, day);
      }
    } catch (e) {
      print('Error parsing date: \$e');
    }
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
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
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

  void _saveChanges() {
    if (_nameController.text.isNotEmpty &&
        _enteredAmount.isNotEmpty &&
        _selectedDate != null) {
      final updatedVoucher = {
        'id': widget.voucherId,
        'name': _nameController.text,
        'discount': _enteredAmount,
        'date': _dateController.text,
      };

      widget.onUpdate(updatedVoucher);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                                  fontSize: screenWidth * 0.06,
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
                            'Edit Voucher',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  _buildInputField('Voucher Name', _nameController),
                  SizedBox(height: screenWidth * 0.08),
                  _buildAmountField(screenWidth),
                  SizedBox(height: screenWidth * 0.08),
                  _buildDateField(context),
                  SizedBox(height: screenWidth * 0.1),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: screenWidth * 0.05,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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

  Widget _buildAmountField(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Discount Amount',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: const Text(
                'RM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expired Date',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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

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

    // 尝试解析现有日期
    try {
      final dateParts = widget.expiredDate.split('/');
      if (dateParts.length == 2) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final currentYear = DateTime.now().year;
        _selectedDate = DateTime(currentYear, month, day);
      }
    } catch (e) {
      print('Error parsing date: $e');
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

      // 创建更新后的优惠券数据
      final updatedVoucher = {
        'id': widget.voucherId,
        'name': _nameController.text,
        'discount': _enteredAmount,
        'date': _dateController.text,
      };

      // 调用回调函数返回更新后的数据
      widget.onUpdate(updatedVoucher);

      // 返回上一页
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background image
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

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button & Title
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        GestureDetector(
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

                        const SizedBox(height: 30),

                        // Title - centered
                        const Center(
                          child: Text(
                            'Edit Voucher',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Voucher Name (editable)
                  _buildInputField('Voucher Name', _nameController),
                  const SizedBox(height: 30),

                  // Discount Amount (editable)
                  _buildAmountField(),
                  const SizedBox(height: 30),

                  // Expired Date (editable)
                  _buildDateField(context),
                  const SizedBox(height: 40),

                  // Save button
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
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

  // Input field with consistent styling
  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  // Discount amount field with RM prefix
  Widget _buildAmountField() {
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  // Only keep digits
                  String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digitsOnly.isEmpty) {
                    _amountController.text = '';
                    setState(() {
                      _enteredAmount = '';
                      _showLimitMessage = false;
                    });
                    return;
                  }

                  // Limit to 5 digits (max RM 999.99)
                  if (digitsOnly.length > 5) {
                    digitsOnly = digitsOnly.substring(0, 5);
                  }

                  // Insert decimal point
                  double numericValue = double.parse(digitsOnly) / 100;

                  // Format to 2 decimal places
                  String formatted = numericValue.toStringAsFixed(2);

                  // Update controller
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

  // Date field with calendar picker
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
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
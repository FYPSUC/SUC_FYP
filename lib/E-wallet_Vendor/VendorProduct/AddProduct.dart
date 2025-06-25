import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class VendorAddProductPage extends StatefulWidget {
  const VendorAddProductPage({super.key});

  @override
  State<VendorAddProductPage> createState() => _VendorAddProductPageState();
}

class _VendorAddProductPageState extends State<VendorAddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  File? _selectedImage;
  String _enteredAmount = '';
  bool _showLimitMessage = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  SizedBox(height: screenHeight * 0.03),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: 选择图片逻辑
                      },
                      child: Container(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: _selectedImage == null
                            ? Icon(Icons.add, size: screenWidth * 0.1, color: Colors.grey)
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildInputField('Product Name', _productNameController, screenWidth),
                  SizedBox(height: screenHeight * 0.03),
                  _buildPriceField(screenWidth),
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String productName = _productNameController.text;
                        String productPrice = _enteredAmount;
                        print('Product Name: $productName');
                        print('Product Price: RM $productPrice');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: screenHeight * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Publish',
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
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

  Widget _buildInputField(String label, TextEditingController controller, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
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

  Widget _buildPriceField(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Price', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
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
              child: Text('RM', style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
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
                    _productPriceController.text = '';
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
                  _productPriceController
                    ..text = formatted
                    ..selection = TextSelection.collapsed(offset: formatted.length);
                  setState(() {
                    _enteredAmount = formatted;
                    _showLimitMessage = numericValue == 1000.00;
                  });
                },
              ),
            ),
          ],
        ),
        if (_showLimitMessage)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Top Up is limited to RM 1,000.00',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035),
            ),
          ),
        const SizedBox(height: 30),
      ],
    );
  }
}

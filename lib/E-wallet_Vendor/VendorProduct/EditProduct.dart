import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:suc_fyp/login_system/api_service.dart';// ✅ 确保你导入了 ApiService.dart

class VendorEditProductPage extends StatefulWidget {
  final String productID;
  final String currentName;
  final String currentPrice;
  final String? currentImageUrl;

  const VendorEditProductPage({
    super.key,
    required this.productID,
    required this.currentName,
    required this.currentPrice,
    this.currentImageUrl,
  });

  @override
  State<VendorEditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<VendorEditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  File? _selectedImage;
  String _enteredAmount = '';
  bool _showLimitMessage = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _priceController = TextEditingController(text: widget.currentPrice);
    _enteredAmount = widget.currentPrice;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
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
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Text(
                      'Edit Product',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: _buildImagePreview(),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildInputField('Product Name', _nameController, screenWidth),
                  SizedBox(height: screenHeight * 0.03),
                  _buildPriceField(screenWidth),
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitProductUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2,
                            vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Publish',
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

  void _submitProductUpdate() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_enteredAmount) ?? 0.0;

    if (name.isEmpty || price <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid name and price')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ApiService.updateProduct(
      productID: widget.productID,
      name: name,
      price: price,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated')),
      );
      Navigator.pop(context, {
        'name': name,
        'price': _enteredAmount,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update product')),
      );
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(_selectedImage!, fit: BoxFit.cover),
      );
    } else if (widget.currentImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(widget.currentImageUrl!, fit: BoxFit.cover),
      );
    } else {
      return const Icon(Icons.add, size: 50, color: Colors.grey);
    }
  }

  Widget _buildInputField(String label, TextEditingController controller, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
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

  Widget _buildPriceField(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Price',
            style: TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold)),
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
              child: Text('RM',
                  style: TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                controller: _priceController,
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
                    _priceController.text = '';
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
                  _priceController
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
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Price is limited to RM 1,000.00',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

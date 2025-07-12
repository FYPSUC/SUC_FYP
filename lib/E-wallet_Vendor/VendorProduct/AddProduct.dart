import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const cloudName = 'dj5err3f6';
  static const uploadPreset = 'flutter_upload';

  static Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      return responseData['secure_url'];
    } else {
      print('Cloudinary upload failed: ${res.body}');
      return null;
    }
  }
}
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
  bool _isLoading = false;


  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitProduct() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      final image_url = await CloudinaryService.uploadImage(_selectedImage!);
      if (image_url == null) {
        throw 'Image upload failed';
      }

      final success = await ApiService.addProduct(
        uid: user.uid,
        name: _productNameController.text,
        price: double.tryParse(_enteredAmount) ?? 0.0,
        image_url: image_url,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add product')));
      }
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }


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
                        Image.asset('assets/image/BackButton.jpg', width: 40, height: 40),
                        SizedBox(width: 10),
                        Text('Back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(child: Text('Add Product', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _selectedImage == null
                            ? Icon(Icons.add, size: 40)
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInputField('Product Name', _productNameController, screenWidth),
                  SizedBox(height: 20),
                  _buildPriceField(screenWidth),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Publish', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Price', style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
              ),
              child: Text('RM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digitsOnly.isEmpty) {
                    _productPriceController.text = '';
                    setState(() {
                      _enteredAmount = '';
                      _showLimitMessage = false;
                    });
                    return;
                  }
                  final cappedDigits = digitsOnly.length > 7 ? digitsOnly.substring(0, 7) : digitsOnly;
                  double numericValue = double.parse(cappedDigits) / 100;
                  if (numericValue > 1000.00) numericValue = 1000.00;
                  final formatted = numericValue.toStringAsFixed(2);
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
            child: Text('Price is limited to RM 1,000.00', style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
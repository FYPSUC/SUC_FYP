import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 数字输入限制
import 'dart:io'; // 文件处理

class VendorAddProductPage extends StatefulWidget {
  const VendorAddProductPage({super.key});

  @override
  State<VendorAddProductPage> createState() => _VendorAddProductPageState();
}

class _VendorAddProductPageState extends State<VendorAddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  File? _selectedImage;                // 存储选择的图片
  String _enteredAmount = '';          // 格式化后的金额文本
  bool _showLimitMessage = false;      // 是否显示超限提示

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 背景图
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
          // 主内容
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 返回按钮 & 标题 & 上传图片
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'Add Product',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: 调用图片选择器并设置 _selectedImage
                            },
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                              child: _selectedImage == null
                                  ? const Icon(Icons.add, size: 50, color: Colors.grey)
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(_selectedImage!, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 商品名称
                  _buildInputField('Product Name', _productNameController),
                  const SizedBox(height: 30),
                  // 商品价格（带格式化与限制）
                  _buildPriceField(),
                  const SizedBox(height: 40),
                  // 发布按钮
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String productName = _productNameController.text;
                        String productPrice = _enteredAmount;
                        // TODO: 保存到数据库或接口调用
                        print('Product Name: $productName');
                        print('Product Price: RM $productPrice');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Publish',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

  // 普通输入框构建
  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  // 价格输入框（带 RM 标签、格式化、最大值限制和提示）
  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Price',
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
                  // 只保留数字
                  String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digitsOnly.isEmpty) {
                    _productPriceController.text = '';
                    setState(() {
                      _enteredAmount = '';
                      _showLimitMessage = false;
                    });
                    return;
                  }
                  // 最多 7 位数字
                  if (digitsOnly.length > 7) {
                    digitsOnly = digitsOnly.substring(0, 7);
                  }
                  // 插入小数点
                  double numericValue = double.parse(digitsOnly) / 100;
                  // 限制最大值
                  if (numericValue > 1000.00) {
                    numericValue = 1000.00;
                    digitsOnly = '100000';
                  }
                  String formatted = numericValue.toStringAsFixed(2);
                  // 更新文本与光标
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
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Top Up is limited to RM 1,000.00',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 30),
      ],
    );
  }
}

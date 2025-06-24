import 'package:flutter/material.dart';
import 'VendorMain.dart'; // 确保导入主页面用于导航

class VendorSetShopPage extends StatefulWidget {
  const VendorSetShopPage({super.key});

  @override
  State<VendorSetShopPage> createState() => _SetShopPageState();
}

class _SetShopPageState extends State<VendorSetShopPage> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _pickUpAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 可以在这里初始化预设值
    _shopNameController.text = 'The Alley';
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _pickUpAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 返回按钮和标题 - 修改后的布局
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 返回按钮带 "Back" 文字
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 标题 - 居中显示
                        const SizedBox(height: 30),
                        // 修改处：使用Center包裹标题
                        const Center(
                          child: Text(
                            'Set Shop Information',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 新增的广告图片部分
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Advertise Pictures',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/image/TheAlley_LongPicture.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Shop Name 输入框
                  _buildInputField('Shop Name', _shopNameController),
                  const SizedBox(height: 30),

                  // Pick Up Address 输入框（多行）
                  _buildAddressField(),
                  const SizedBox(height: 40),

                  // 提交按钮
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // 处理提交逻辑
                        String shopName = _shopNameController.text;
                        String pickUpAddress = _pickUpAddressController.text;

                        // 打印结果（实际应用中应保存到数据库）
                        print('Shop Name: $shopName');
                        print('Pick Up Address: $pickUpAddress');

                        // 返回上一页
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // 按钮背景色
                        foregroundColor: Colors.white, // 文字颜色
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 20),
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
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick Up Address',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _pickUpAddressController,
          maxLines: 4, // 多行文本
          decoration: InputDecoration(
            hintText: 'Enter your shop address',
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
}
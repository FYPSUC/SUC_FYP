import 'package:flutter/material.dart';

class VendorSetShopPage extends StatefulWidget {
  const VendorSetShopPage({super.key});

  @override
  State<VendorSetShopPage> createState() => _VendorSetShopPageState();
}

class _VendorSetShopPageState extends State<VendorSetShopPage> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _pickUpAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _shopNameController.text = 'The Alley'; // 预设值
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
      resizeToAvoidBottomInset: true,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // 返回按钮
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/image/BackButton.jpg',
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Back',
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Center(
                              child: Text(
                                'Set Shop Information',
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // 图片展示
                            const Text(
                              'Advertise Pictures',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            const SizedBox(height: 30),
                            // 店名
                            _buildInputField('Shop Name', _shopNameController),
                            const SizedBox(height: 30),
                            // 地址
                            _buildAddressField(),
                            const Spacer(),
                            const SizedBox(height: 40),
                            // 提交按钮
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  String shopName = _shopNameController.text;
                                  String pickUpAddress = _pickUpAddressController.text;
                                  print('Shop Name: $shopName');
                                  print('Pick Up Address: $pickUpAddress');
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text('Submit', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick Up Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          controller: _pickUpAddressController,
          maxLines: 4,
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

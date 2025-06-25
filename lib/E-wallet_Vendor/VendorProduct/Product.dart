import 'package:flutter/material.dart';
import 'AddProduct.dart';
import 'EditProduct.dart';

class VendorProductPage extends StatefulWidget {
  const VendorProductPage({super.key});

  @override
  State<VendorProductPage> createState() => _VendorProductPageState();
}

class _VendorProductPageState extends State<VendorProductPage> {
  // 模拟商品数据
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Pearl milk tea',
      'price': 'RM 8.0',
      'image': 'assets/image/pearl_milk_tea.png',
    },
    {
      'name': 'Garden milk tea',
      'price': 'RM 10.0',
      'image': 'assets/image/garden_milk_tea.png',
    },
  ];

  // 删除商品
  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _products.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 编辑商品
  void _editProduct(int index) {
    final product = _products[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorEditProductPage(
          currentName: product['name'],
          currentPrice: product['price'].replaceAll('RM ', ''),
        ),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          _products[index] = {
            ..._products[index],
            'name': value['name'],
            'price': 'RM ${value['price']}',
          };
        });
      }
    });
  }

  // 添加新商品
  void _addNewProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VendorAddProductPage()),
    ).then((value) {
      if (value != null) {
        setState(() {
          _products.add({
            'name': value['name'],
            'price': 'RM ${value['price']}',
            'image': value['image'] ?? 'assets/image/default_product.png',
          });
        });
      }
    });
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
                  // 返回按钮和标题
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
                            'My Product',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 商品列表
                  Expanded(
                    child: _products.isEmpty
                        ? const Center(
                      child: Text(
                        'No products available.',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return _buildProductCard(
                          name: product['name'],
                          price: product['price'],
                          image: product['image'],
                          onDelete: () => _deleteProduct(index),
                          onEdit: () => _editProduct(index),
                        );
                      },
                    ),
                  ),

                  // 添加商品按钮
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 10),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: _addNewProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 28),
                        label: const Text(
                          'Add Product',
                          style: TextStyle(fontSize: 20),
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

  // 商品卡片
  Widget _buildProductCard({
    required String name,
    required String price,
    required String image,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(price, style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Delete'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

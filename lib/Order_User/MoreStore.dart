import 'package:flutter/material.dart';
import 'package:suc_fyp/Order_User/Order.dart';

class MoreStorePage extends StatefulWidget {
  @override
  _MoreStorePageState createState() => _MoreStorePageState();
}

class _MoreStorePageState extends State<MoreStorePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, String>> stores = [
    {
      'name': 'The Alley\n - IEB',
      'image': 'assets/image/TheAlley.png',
      'location': 'IEB',
    },
    {
      'name': 'Chicken rice store\n - Canteen',
      'image': 'assets/image/ChickenRise.png',
      'location': 'Canteen',
    },
    // 这里可以继续添加更多store
  ];

  @override
  Widget build(BuildContext context) {
    // 根据搜索过滤store
    final filteredStores = stores.where((store) {
      return store['name']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserOrderPage()), // 或者 OrderPage()
                    );
                  },
                  child: Row(
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Search store...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 白色Container包着所有store
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredStores.length,
                      itemBuilder: (context, index) {
                        final store = filteredStores[index];
                        return Column(
                          children: [
                            if (index != 0) const Divider(color: Colors.black, thickness: 2),
                            const SizedBox(height: 20),

                            GestureDetector(
                              onTap: () {
                                // 点击后跳转到对应store页面
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      store['image']!,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      store['name']!,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

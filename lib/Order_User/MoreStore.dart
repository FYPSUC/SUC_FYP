import 'package:flutter/material.dart';
import 'MainStorePage.dart';
import 'package:suc_fyp/Order_User/Order.dart';
import 'models.dart';

class MoreStorePage extends StatefulWidget {
  @override
  _MoreStorePageState createState() => _MoreStorePageState();
}

class _MoreStorePageState extends State<MoreStorePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final List<Store> stores = [
    Store(
      name: 'The Alley',
      location: 'IEB',
      image: 'assets/image/TheAlley.png',
      menu: [
        MenuItem(
          name: 'Pearl milk tea',
          price: 8.00,
          image: 'assets/image/pearl_milk_tea.png',
        ),
        MenuItem(
          name: 'Garden milk tea',
          price: 10.00,
          image: 'assets/image/garden_milk_tea.png',
        ),
      ],
    ),
    Store(
      name: 'Chicken Rice Store',
      location: 'Canteen',
      image: 'assets/image/ChickenRise.png',
      menu: [
        MenuItem(
          name: 'Roasted Chicken Rice',
          price: 7.00,
          image: 'assets/image/Chicken_rise.jpg',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final filteredStores = stores.where((store) {
      return store.name.toLowerCase().contains(searchQuery.toLowerCase());
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserOrderPage()),
                    );
                  },
                  child: Row(
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
                SizedBox(height: screenHeight * 0.03),

                // 搜索栏
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: TextStyle(fontSize: screenWidth * 0.045),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, size: screenWidth * 0.06),
                      hintText: 'Search store...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // 白色容器内的商店列表
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      itemCount: filteredStores.length,
                      itemBuilder: (context, index) {
                        final store = filteredStores[index];
                        return Column(
                          children: [
                            if (index != 0)
                              Divider(color: Colors.black, thickness: 2),
                            SizedBox(height: screenHeight * 0.02),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StoreMenuPage(store: store),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      store.image,
                                      width: screenWidth * 0.3,
                                      height: screenWidth * 0.3,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Expanded(
                                    child: Text(
                                      store.name,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
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

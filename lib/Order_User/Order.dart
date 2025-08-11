import 'package:flutter/material.dart';
import 'MoreStore.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';
import 'models.dart';
import 'MainStorePage.dart';
import 'package:suc_fyp/login_system/api_service.dart'; // 加这一行

class UserOrderPage extends StatelessWidget {
  const UserOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserMainPage())),
                  child: Row(
                    children: [
                      Image.asset('assets/image/BackButton.jpg', width: screenWidth * 0.1, height: screenWidth * 0.1),
                      SizedBox(width: screenWidth * 0.02),
                      Text('Back', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                Expanded(
                  child: FutureBuilder<List<Store>>(
                    future: ApiService.fetchStoresWithProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No stores found'));
                      }

                      final stores = snapshot.data!;
                      // 先收集所有菜单项，按销量降序排序
                      final topMenuItems = stores.expand((store) => store.menu).toList()
                        ..sort((a, b) => b.totalSold.compareTo(a.totalSold));
                      final top3 = topMenuItems.take(3).toList();


                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ PageView 展示前两个店家的广告图
                            SizedBox(
                              height: screenHeight * 0.2,
                              child: PageView(
                                children: stores
                                    .where((store) => store.image.isNotEmpty && Uri.tryParse(store.image)?.hasAbsolutePath == true)
                                    .take(2)
                                    .map((store) {

                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoreMenuPage(store: store),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.network(store.image, fit: BoxFit.cover),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MoreStorePage())),
                                child: Text(
                                  'More store',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.045,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            Text(
                              'Today ranking',
                              style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
                            ),
                            const Divider(color: Colors.black, thickness: 1),

                            // 展示销量前 3 的商品
                            ...top3.map((menuItem) {
                              return RankingItem(
                                rank: 'Top ${top3.indexOf(menuItem) + 1}',
                                imagePath: menuItem.image,
                                title: menuItem.name,
                                price: 'RM ${menuItem.price.toStringAsFixed(2)}',
                                onTap: () {
                                  if (menuItem.isSoldOut != 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('This item is sold out')),
                                    );
                                    return;
                                  }
                                  final store =
                                  stores.firstWhere((s) => s.menu.contains(menuItem));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreMenuPage(store: store)),
                                  );
                                },
                                screenWidth: MediaQuery.of(context).size.width,
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
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

class RankingItem extends StatelessWidget {
  final String rank;
  final String imagePath;
  final String title;
  final String price;
  final VoidCallback onTap;
  final double screenWidth;

  const RankingItem({
    super.key,
    required this.rank,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.onTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        child: Row(
          children: [
            Text(
              rank,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imagePath.startsWith("http")
                  ? Image.network(
                imagePath,
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                imagePath,
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                  Text(price, style: TextStyle(fontSize: screenWidth * 0.04)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

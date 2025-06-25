import 'package:flutter/material.dart';
import 'MoreStore.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';
import 'models.dart';
import 'MainStorePage.dart';

class UserOrderPage extends StatelessWidget {
  UserOrderPage({Key? key}) : super(key: key);

  final List<Store> stores = [
    Store(
      name: 'The Alley',
      location: 'IEB',
      image: 'assets/image/TheAlley.png',
      menu: [
        MenuItem(name: 'Pearl milk tea', price: 8.00, image: 'assets/image/pearl_milk_tea.png'),
        MenuItem(name: 'Garden milk tea', price: 10.00, image: 'assets/image/garden_milk_tea.png'),
      ],
    ),
    Store(
      name: 'Chicken Rice Store',
      location: 'Canteen',
      image: 'assets/image/ChickenRise.png',
      menu: [
        MenuItem(name: 'Roasted Chicken Rice', price: 7.00, image: 'assets/image/Chicken_rise.jpg'),
      ],
    ),
  ];

  Store getStoreByName(String name) {
    return stores.firstWhere((store) => store.name == name);
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.2, // 你可以根据需要调整这个比例
                          child: PageView(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreMenuPage(store: getStoreByName('The Alley')),
                                  ),
                                ),
                                child: SizedBox(
                                  height: screenHeight * 0.2, // 或者写固定高度 e.g., 180
                                  child: Image.asset(
                                    'assets/image/TheAlley_LongPicture.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreMenuPage(store: getStoreByName('Chicken Rice Store')),
                                  ),
                                ),
                                child: SizedBox(
                                  height: screenHeight * 0.25,
                                  child: Image.asset(
                                    'assets/image/ChickenRise_LongPicture.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
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

                        RankingItem(
                          rank: 'Top 1',
                          imagePath: 'assets/image/pearl_milk_tea.png',
                          title: 'Boba tea',
                          price: 'RM 8',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoreMenuPage(store: getStoreByName('The Alley')))),
                          screenWidth: screenWidth,
                        ),
                        RankingItem(
                          rank: 'Top 2',
                          imagePath: 'assets/image/ChickenRise.png',
                          title: 'Chicken rice',
                          price: 'RM 7',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoreMenuPage(store: getStoreByName('Chicken Rice Store')))),
                          screenWidth: screenWidth,
                        ),
                        RankingItem(
                          rank: 'Top 3',
                          imagePath: 'assets/image/garden_milk_tea.png',
                          title: 'Garden milk tea',
                          price: 'RM 10',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoreMenuPage(store: getStoreByName('The Alley')))),
                          screenWidth: screenWidth,
                        ),
                      ],
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
              child: Image.asset(
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

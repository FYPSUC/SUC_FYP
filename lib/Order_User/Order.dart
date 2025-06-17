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

  Store getStoreByName(String name) {
    return stores.firstWhere((store) => store.name == name);
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserMainPage()),
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
                const SizedBox(height: 40),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          child: PageView(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoreMenuPage(store: getStoreByName('The Alley')),
                                    ),
                                  );
                                },
                                child: Image.asset('assets/image/TheAlley_LongPicture.png', fit: BoxFit.cover),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoreMenuPage(store: getStoreByName('Chicken Rice Store')),
                                    ),
                                  );
                                },
                                child: Image.asset('assets/image/ChickenRise_LongPicture.png', fit: BoxFit.cover),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MoreStorePage()),
                              );
                            },
                            child: const Text(
                              'More store',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          'Today ranking',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),

                        // 排名列表
                        RankingItem(
                          rank: 'Top 1',
                          imagePath: 'assets/image/pearl_milk_tea.png',
                          title: 'Boba tea',
                          price: 'RM 8',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreMenuPage(store: getStoreByName('The Alley')),
                              ),
                            );
                          },
                        ),
                        RankingItem(
                          rank: 'Top 2',
                          imagePath: 'assets/image/ChickenRise.png',
                          title: 'Chicken rise',
                          price: 'RM 7',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreMenuPage(store: getStoreByName('Chicken Rice Store')),
                              ),
                            );
                          },
                        ),
                        RankingItem(
                          rank: 'Top 3',
                          imagePath: 'assets/image/garden_milk_tea.png',
                          title: 'Garden milk tea',
                          price: 'RM 10',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreMenuPage(store: getStoreByName('The Alley')),
                              ),
                            );
                          },
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

  const RankingItem({
    required this.rank,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(
              rank,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(price, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

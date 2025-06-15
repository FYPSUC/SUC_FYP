import 'package:flutter/material.dart';
import 'MoreStore.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';

class UserOrderPage extends StatelessWidget {
  const UserOrderPage({Key? key}) : super(key: key);
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

                // 返回按钮
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserMainPage()), // 或者 OrderPage()
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
                        // 轮播图
                        SizedBox(
                          height: 180,
                          child: PageView(
                            children: [
                              Image.asset('assets/image/TheAlley_LongPicture.png', fit: BoxFit.cover),
                              Image.asset('assets/image/ChickenRise_LongPicture.png', fit: BoxFit.cover),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // More store 按钮
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
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
                          price: 'RM 6',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BobaTeaPage()), // 需要创建页面
                            );
                          },
                        ),
                        RankingItem(
                          rank: 'Top 2',
                          imagePath: 'assets/image/ChickenRise.png',
                          title: 'Chicken rise',
                          price: 'RM 5',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChickenRicePage()), // 需要创建页面
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
                              MaterialPageRoute(builder: (context) => GardenMilkTeaPage()), // 需要创建页面
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

class BobaTeaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boba Tea')),
      body: const Center(child: Text('Boba Tea Page')),
    );
  }
}

class ChickenRicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chicken Rice')),
      body: const Center(child: Text('Chicken Rice Page')),
    );
  }
}

class GardenMilkTeaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garden Milk Tea')),
      body: const Center(child: Text('Garden Milk Tea Page')),
    );
  }
}

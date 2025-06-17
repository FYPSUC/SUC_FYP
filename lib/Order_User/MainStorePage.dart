import 'package:flutter/material.dart';
import 'models.dart' as models;
import 'OrderPurchase.dart'; // 导入订单总结页面

class StoreMenuPage extends StatefulWidget {
  final models.Store store;

  const StoreMenuPage({super.key, required this.store});

  @override
  _StoreMenuPageState createState() => _StoreMenuPageState();
}

class _StoreMenuPageState extends State<StoreMenuPage> {
  final Map<String, int> itemCounts = {};

  @override
  void initState() {
    super.initState();
    for (var item in widget.store.menu) {
      itemCounts[item.name] = 0;
    }
  }

  double get totalPrice {
    double total = 0;
    widget.store.menu.forEach((item) {
      total += itemCounts[item.name]! * item.price;
    });
    return total;
  }

  int get totalItems => itemCounts.values.fold(0, (sum, count) => sum + count);

  void increaseItem(String itemName) {
    setState(() => itemCounts[itemName] = itemCounts[itemName]! + 1);
  }

  void decreaseItem(String itemName) {
    setState(() {
      if (itemCounts[itemName]! > 0) {
        itemCounts[itemName] = itemCounts[itemName]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
                const SizedBox(height: 18),
                // 返回按钮
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 商店信息
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.store.image,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${widget.store.name}\n - ${widget.store.location}',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // 菜单标题
                const Text('Menu', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),

                // 菜单项列表
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.store.menu.length,
                    itemBuilder: (context, index) {
                      final item = widget.store.menu[index];
                      final count = itemCounts[item.name]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                item.image,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                                  Text('RM ${item.price.toStringAsFixed(1)}', style: const TextStyle(fontSize: 23)),
                                ],
                              ),
                            ),
                            if (count == 0)
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 30),
                                onPressed: () => increaseItem(item.name),
                              )
                            else
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 30),
                                    onPressed: () => decreaseItem(item.name),
                                  ),
                                  Text('$count', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 30),
                                    onPressed: () => increaseItem(item.name),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 购物篮
                if (totalItems > 0)
                  GestureDetector(
                    onTap: () {
                      Map<models.MenuItem, int> selectedItems = {};
                      for (var item in widget.store.menu) {
                        if (itemCounts[item.name]! > 0) {
                          selectedItems[item] = itemCounts[item.name]!;
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryPage(
                              selectedItems: selectedItems.map((item, count) =>
                                  MapEntry<models.MenuItem, int>(item as models.MenuItem, count))
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        'Basket • $totalItems Item${totalItems > 1 ? 's' : ''} RM ${totalPrice.toStringAsFixed(1)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
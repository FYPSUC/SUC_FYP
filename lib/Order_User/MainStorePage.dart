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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
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
                          width: screenWidth * 0.3,
                          height: screenWidth * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Text(
                          '${widget.store.name}\n - ${widget.store.location}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.001),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.store.menu.length,
                    itemBuilder: (context, index) {
                      final item = widget.store.menu[index];
                      final count = itemCounts[item.name]!;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                item.image,
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.055,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'RM ${item.price.toStringAsFixed(1)}',
                                    style: TextStyle(fontSize: screenWidth * 0.05),
                                  ),
                                ],
                              ),
                            ),
                            count == 0
                                ? IconButton(
                              icon: Icon(Icons.add_circle_outline, size: screenWidth * 0.07),
                              onPressed: () => increaseItem(item.name),
                            )
                                : Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, size: screenWidth * 0.07),
                                  onPressed: () => decreaseItem(item.name),
                                ),
                                Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, size: screenWidth * 0.07),
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
                if (totalItems > 0)
                  GestureDetector(
                    onTap: () {
                      final selectedItems = {
                        for (var item in widget.store.menu)
                          if (itemCounts[item.name]! > 0) item: itemCounts[item.name]!,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryPage(selectedItems: selectedItems),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        'Basket • $totalItems Item${totalItems > 1 ? 's' : ''} RM ${totalPrice.toStringAsFixed(1)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                        ),
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
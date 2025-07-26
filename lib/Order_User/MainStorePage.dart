import 'package:flutter/material.dart';
import 'models.dart' as models;
import 'OrderPurchase.dart';

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

  double get totalPrice => widget.store.menu.fold(
    0,
        (sum, item) => sum + (itemCounts[item.name]! * item.price),
  );

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
                      Image.asset('assets/image/BackButton.jpg', width: screenWidth * 0.1),
                      SizedBox(width: screenWidth * 0.02),
                      Text('Back', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.store.image.startsWith('http')
                            ? Image.network(widget.store.image, width: screenWidth * 0.25, height: screenWidth * 0.25, fit: BoxFit.cover)
                            : Image.asset(widget.store.image, width: screenWidth * 0.25, height: screenWidth * 0.25, fit: BoxFit.cover),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ShopName: ${widget.store.name}', style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('PickupAddress: ${widget.store.location}', style: TextStyle(fontSize: screenWidth * 0.045)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text('Menu', style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold)),
                SizedBox(height: screenHeight * 0.015),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.store.menu.length,
                    itemBuilder: (context, index) {
                      final item = widget.store.menu[index];
                      final count = itemCounts[item.name]!;
                      print('Item: ${item.name}, isSoldOut: ${item.isSoldOut}');
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: item.image.startsWith('http')
                                  ? Image.network(item.image, width: screenWidth * 0.25, height: screenWidth * 0.25, fit: BoxFit.cover)
                                  : Image.asset(item.image, width: screenWidth * 0.25, height: screenWidth * 0.25, fit: BoxFit.cover),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('RM ${item.price.toStringAsFixed(2)}', style: TextStyle(fontSize: screenWidth * 0.045)),

                                  if (item.isSoldOut != 0)


                                    Text(
                                      'Sold Out',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                if (count > 0)
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () => decreaseItem(item.name),
                                  ),
                                Text('$count', style: TextStyle(fontSize: screenWidth * 0.045)),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: item.isSoldOut != 0 ? null : () => increaseItem(item.name),
                                ),
                              ],
                            )

                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (totalItems > 0)
                  GestureDetector(
                    onTap: () {
                      if (widget.store.vendorUID.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid vendor UID, please try again later.')),
                        );
                        return;
                      }

                      final selectedItems = {
                        for (var item in widget.store.menu)
                          if (itemCounts[item.name]! > 0) item: itemCounts[item.name]!,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryPage(selectedItems: selectedItems,vendorUID: widget.store.vendorUID,),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.01),
                      padding: EdgeInsets.all(screenWidth * 0.035),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Basket • $totalItems item${totalItems > 1 ? "s" : ""} • RM ${totalPrice.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold),
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

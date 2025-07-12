// ✅ 更新后的 MoreStorePage：从 API 动态获取 stores
import 'package:flutter/material.dart';
import 'MainStorePage.dart';
import 'models.dart';
import 'package:suc_fyp/Order_User/Order.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class MoreStorePage extends StatefulWidget {
  @override
  _MoreStorePageState createState() => _MoreStorePageState();
}

class _MoreStorePageState extends State<MoreStorePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late Future<List<Store>> _futureStores;

  @override
  void initState() {
    super.initState();
    _futureStores = ApiService.fetchStoresWithProducts();
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
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Search store...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Expanded(
                  child: FutureBuilder<List<Store>>(
                    future: _futureStores,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: \${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No stores found'));
                      }

                      final filteredStores = snapshot.data!.where((store) =>
                          store.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

                      return ListView.builder(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        itemCount: filteredStores.length,
                        itemBuilder: (context, index) {
                          final store = filteredStores[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                            padding: EdgeInsets.all(screenWidth * 0.025),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => StoreMenuPage(store: store),
                                  transitionsBuilder: (_, anim, __, child) => SlideTransition(
                                    position: Tween(begin: Offset(1, 0), end: Offset.zero).animate(anim),
                                    child: child,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: store.image.startsWith('http')
                                        ? Image.network(store.image, width: screenWidth * 0.3, height: screenWidth * 0.3, fit: BoxFit.cover)
                                        : Image.asset(store.image, width: screenWidth * 0.3, height: screenWidth * 0.3, fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(store.name, style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 6),
                                        Text(store.location, style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[600])),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/Order_User/models.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class UserVoucherPage extends StatefulWidget {
  final Function(Voucher) onVoucherSelected;
  final String? vendorUID;

  const UserVoucherPage({super.key, required this.onVoucherSelected,this.vendorUID,});

  @override
  State<UserVoucherPage> createState() => _UserVoucherPageState();
}

class _UserVoucherPageState extends State<UserVoucherPage> {
  List<Voucher> vouchers = [];
  List<int> collectedVoucherIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final allVouchers = widget.vendorUID != null
        ? await ApiService.getVendorVouchers(widget.vendorUID!)
        : await ApiService.getAllVouchers();


    final collected = await ApiService.getCollectedVoucherIds(user.uid);

    setState(() {
      vouchers = (allVouchers as List).map((item) {
        if (item is Voucher) {
          return item;
        } else if (item is Map<String, dynamic>) {
          return Voucher.fromJson(item);
        } else {
          throw Exception('Unknown voucher data format');
        }
      }).toList();
      collectedVoucherIds = collected;
      isLoading = false;
    });


  }

  Future<void> collectVoucher(Voucher voucher) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final success = await ApiService.claimVoucher(user.uid, voucher.id);
    if (success) {
      setState(() {
        collectedVoucherIds.add(voucher.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voucher "${voucher.name}" collected!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.05),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/image/BackButton.jpg',
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
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
                ),
                SizedBox(height: screenWidth * 0.1),

                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: screenWidth * 0.05),
                        child: CouponCard(
                          screenWidth: screenWidth,
                          merchantName: voucher.vendorName,
                          offer:
                          "RM ${voucher.discount.toStringAsFixed(0)} Off",
                          expiry:
                          "Use before ${voucher.expiredDate}",
                          logoAsset: "assets/image/Voucher_icon.png",
                          voucher: voucher,
                          isCollected: collectedVoucherIds
                              .contains(voucher.id),
                          onUse: (v) {
                            widget.onVoucherSelected(v);
                            Navigator.pop(context);
                          },
                          onCollect: collectVoucher,
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

class CouponCard extends StatefulWidget {
  final double screenWidth;
  final String merchantName;
  final String offer;
  final String expiry;
  final String logoAsset;
  final Voucher voucher;
  final bool isCollected;
  final Function(Voucher) onUse;
  final Function(Voucher) onCollect;

  const CouponCard({
    super.key,
    required this.screenWidth,
    required this.merchantName,
    required this.offer,
    required this.expiry,
    required this.logoAsset,
    required this.voucher,
    required this.isCollected,
    required this.onUse,
    required this.onCollect,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  late bool isCollected;

  @override
  void initState() {
    super.initState();
    isCollected = widget.isCollected;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 0.4;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left logo
              Container(
                width: width * 0.35,
                decoration: const BoxDecoration(
                  color: Color(0xFF2596BE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      widget.logoAsset,
                      fit: BoxFit.contain,
                      width: width * 0.3,
                      height: width * 0.3,
                    ),
                  ),
                ),
              ),

              // Right info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: width * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.merchantName,
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: width * 0.015),
                          Text(
                            widget.offer,
                            style: TextStyle(
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2596BE),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.expiry,
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (isCollected) {
                                widget.onUse(widget.voucher);
                              } else {
                                await widget.onCollect(widget.voucher);
                                setState(() {
                                  isCollected = true;
                                });
                              }
                            },
                            child: Container(
                              width: width * 0.23,
                              height: width * 0.12,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2596BE),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                isCollected ? "Use" : "Collect",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

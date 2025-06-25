import 'package:flutter/material.dart';
import 'package:suc_fyp/Order_User/models.dart';

class UserVoucherPage extends StatelessWidget {
  final Function(Voucher) onVoucherSelected;

  const UserVoucherPage({super.key, required this.onVoucherSelected});

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
                // Back按钮
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

                // 优惠券部分
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CouponCard(
                          screenWidth: screenWidth,
                          merchantName: "The Alley",
                          offer: "RM 5 Off",
                          expiry: "Use before 30/12",
                          logoAsset: "assets/image/Voucher_icon.png",
                          voucher: Voucher(code: 'SAVE5', discount: 5.0),
                          onUse: (voucher) {
                            onVoucherSelected(voucher);
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        CouponCard(
                          screenWidth: screenWidth,
                          merchantName: "Chicken Rise Store",
                          offer: "RM 3 Off",
                          expiry: "Use before 15/12",
                          logoAsset: "assets/image/Voucher_icon.png",
                          voucher: Voucher(code: 'SAVE3', discount: 3.0),
                          onUse: (voucher) {
                            onVoucherSelected(voucher);
                            Navigator.pop(context);
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

class CouponCard extends StatefulWidget {
  final double screenWidth;
  final String merchantName;
  final String offer;
  final String expiry;
  final String logoAsset;
  final Voucher voucher;
  final Function(Voucher) onUse;

  const CouponCard({
    super.key,
    required this.screenWidth,
    required this.merchantName,
    required this.offer,
    required this.expiry,
    required this.logoAsset,
    required this.voucher,
    required this.onUse,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isCollected = false;

  @override
  Widget build(BuildContext context) {
    final width = widget.screenWidth * 0.9;
    final height = widget.screenWidth * 0.35;

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
                      Text(
                        widget.expiry,
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isCollected) {
                            widget.onUse(widget.voucher);
                          } else {
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
  }
}

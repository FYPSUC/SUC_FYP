import 'package:flutter/material.dart';
import 'package:suc_fyp/Order_User/models.dart';

class UserVoucherPage extends StatelessWidget {
  final Function(Voucher) onVoucherSelected;

  const UserVoucherPage({super.key, required this.onVoucherSelected});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back按钮
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Image.asset('assets/image/BackButton.jpg', width: 40, height: 40),
                        const SizedBox(width: 8),
                        const Text('Back', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 优惠券部分
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CouponCard(
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
                        const SizedBox(height: 20),
                        CouponCard(
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
  final String merchantName;
  final String offer;
  final String expiry;
  final String logoAsset;
  final Voucher voucher;
  final Function(Voucher) onUse;

  const CouponCard({
    super.key,
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
    return Container(
      width: 350,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2596BE),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(widget.logoAsset, fit: BoxFit.contain, width: 120, height: 120),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.merchantName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text(widget.offer, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2596BE))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.expiry, style: TextStyle(fontSize: 15, color: Colors.grey[700], fontWeight: FontWeight.w500)),
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
                          width: 75,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: const Color(0xFF2596BE), borderRadius: BorderRadius.circular(7)),
                          child: Text(isCollected ? "Use" : "Collect", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class VendorQRReceivePage extends StatefulWidget {
  const VendorQRReceivePage({super.key});

  @override
  State<VendorQRReceivePage> createState() => _VendorQRReceivePageState();
}

class _VendorQRReceivePageState extends State<VendorQRReceivePage> {
  String? qrData;
  String? vendorName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQRData();
  }

  Future<void> fetchQRData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final qrResponse = await ApiService.getQRDataByUID(user.uid);
        final vendorResponse = await ApiService.getVendorByUID(user.uid);

        if (!mounted) return;

        if (qrResponse['success'] && vendorResponse['success']) {
          setState(() {
            qrData = qrResponse['qr_data'];
            vendorName = vendorResponse['user']['username']; // 注意 key 是 "user"
            isLoading = false;
          });
        } else {
          setState(() {
            qrData = null;
            vendorName = null;
            isLoading = false;
          });
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          qrData = null;
          vendorName = null;
          isLoading = false;
        });
      }
    }
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Scan this QR code to transfer to",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          vendorName ?? "Vendor",
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        qrData != null
                            ? QrImageView(
                          data: qrData!,
                          version: QrVersions.auto,
                          size: screenWidth * 0.7,
                          backgroundColor: Colors.white,
                        )
                            : const Text(
                          "QR Code not available",
                          style: TextStyle(color: Colors.red),
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

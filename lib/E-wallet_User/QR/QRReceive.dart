import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:suc_fyp/login_system/api_service.dart';

class UserQRReceivePage extends StatefulWidget {
  const UserQRReceivePage({super.key});

  @override
  State<UserQRReceivePage> createState() => _UserQRReceivePageState();
}

class _UserQRReceivePageState extends State<UserQRReceivePage> {
  String? qrData;
  String? username;
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
        final userResponse = await ApiService.getUserByUID(user.uid);

        if (qrResponse['success'] && userResponse['success']) {
          setState(() {
            qrData = qrResponse['qr_data'];
            username = userResponse['user']['username'];
            isLoading = false;
          });
        } else {
          setState(() {
            qrData = null;
            username = null;
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          qrData = null;
          username = null;
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
                // 返回按钮
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

                // 内容
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
                          username ?? "Username",
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

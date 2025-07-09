import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'VendorQRScanPayment.dart';

class VendorQRScanPage extends StatefulWidget {
  const VendorQRScanPage({super.key});

  @override
  State<VendorQRScanPage> createState() => _VendorQRScanPageState();
}

class _VendorQRScanPageState extends State<VendorQRScanPage> {
  bool isScanning = true;
  bool isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        isPermissionGranted = true;
      });
    } else {
      openAppSettings(); // 引导用户去设置权限
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && isScanning) {
        isScanning = false;

        if (code.startsWith('firebase_uid:')) {
          final uid = code.replaceFirst('firebase_uid:', '');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VendorQRScanPaymentPage(qrData: uid),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid QR Code')),
          );
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isScanning = true;
            });
          });
        }
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
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
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
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan QR code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isPermissionGranted
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    controller: MobileScannerController(
                      facing: CameraFacing.back,
                    ),
                    onDetect: _onDetect,
                  ),
                )
                    : const Center(
                  child: Text(
                    'Camera permission denied',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

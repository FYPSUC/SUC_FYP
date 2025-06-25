import 'package:flutter/material.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';
import 'Booking.dart';
import 'HIstoryAppointment.dart';

class UserClinicPage extends StatelessWidget {
  const UserClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                // 顶部返回按钮
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: GestureDetector(
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
                ),

                // 中间 Clinic 标题
                Expanded(
                  child: Center(
                    child: Text(
                      'Clinic',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 底部按钮
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildClinicButton(
                        context,
                        iconPath: 'assets/image/HistoryAppointment_icon.png',
                        label: 'History\nAppointment',
                        onTap: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (
                                  context) => const ClinicHistoryAppointmentPage()),
                            ),
                        screenWidth: screenWidth,
                      ),
                      buildClinicButton(
                        context,
                        iconPath: 'assets/image/Booking_icon.png',
                        label: 'Booking',
                        onTap: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (
                                  context) => const ClinicCalendarPage()),
                            ),
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildClinicButton(BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: screenWidth * 0.38,
            height: screenWidth * 0.52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.025),
        // ⬇ label区域统一高度
        SizedBox(
          height: screenWidth * 0.18, // 固定label高度
          width: screenWidth * 0.38,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2, // 控制行距
              ),
            ),
          ),
        ),
      ],
    );
  }
}
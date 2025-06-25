import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suc_fyp/E-wallet_User/UserMain.dart';

class ClinicCalendarPage extends StatefulWidget {
  const ClinicCalendarPage({super.key});

  @override
  State<ClinicCalendarPage> createState() => _ClinicCalendarPageState();
}

class _ClinicCalendarPageState extends State<ClinicCalendarPage> {
  DateTime? selectedDate;
  bool showBookingInput = false;
  String? selectedTime;

  final TextEditingController _bookingController = TextEditingController();

  final List<Map<String, dynamic>> timeSlots = [
    {'time': '10:00 am', 'available': true},
    {'time': '11:00 am', 'available': false},
    {'time': '12:00 pm', 'available': false},
    {'time': '01:00 pm', 'available': false},
    {'time': '02:00 pm', 'available': false},
    {'time': '03:00 pm', 'available': false},
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        showBookingInput = false;
        selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
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
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Calendar',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        selectedDate != null
                            ? DateFormat('d / M / yyyy').format(selectedDate!)
                            : 'Choose date',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: selectedDate != null
                              ? Colors.black
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                if (selectedDate != null)
                  Expanded(
                    child: showBookingInput
                        ? _buildSelectedSlotAndBookingInput(screenWidth, screenHeight)
                        : _buildTimeSlots(screenWidth),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots(double screenWidth) {
    return ListView.builder(
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        return GestureDetector(
          onTap: () {
            if (slot['available']) {
              setState(() {
                showBookingInput = true;
                selectedTime = slot['time'];
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slot['time'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  slot['available'] ? 'available' : 'unavailable',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: slot['available'] ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedSlotAndBookingInput(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedTime ?? '',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
          ),
          child: TextField(
            controller: _bookingController,
            decoration: InputDecoration(
              hintText: 'Enter something...'
              ,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: screenWidth * 0.045),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.black),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        ElevatedButton(
          onPressed: () {
            if (_bookingController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter booking note')),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successful booking')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserMainPage()),
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.02,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(color: Colors.black),
          ),
          child: Text(
            'Booking',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

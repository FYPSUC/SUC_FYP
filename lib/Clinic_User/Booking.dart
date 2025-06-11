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
        showBookingInput = false; // 选择新日期时，重置状态
      });
    }
  }

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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/BackButton.jpg',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Back',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Calendar',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // 日期选择框
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    height: 60,
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
                          fontSize: 25,
                          color: selectedDate != null
                              ? Colors.black
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 时间选择部分或输入框
                if (selectedDate != null)
                  Expanded(
                    child: showBookingInput
                        ? _buildSelectedSlotAndBookingInput()
                        : _buildTimeSlots(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return ListView.builder(
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        return GestureDetector(
          onTap: () {
            if (slot['available']) {
              setState(() {
                showBookingInput = true;
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
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  slot['available'] ? 'available' : 'unavailable',
                  style: TextStyle(
                    fontSize: 18,
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

  Widget _buildSelectedSlotAndBookingInput() {
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
            children: const [
              Text(
                '10:00 am',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
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
              hintText: 'Enter something...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successful booking')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserMainPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(color: Colors.black),
          ),
          child: const Text(
            'Booking',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

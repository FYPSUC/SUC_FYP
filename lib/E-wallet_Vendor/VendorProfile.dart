import 'package:flutter/material.dart';
import 'VendorMain.dart';
import 'VendorSetShop.dart';

class VendorProfilePage extends StatelessWidget {
  const VendorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/UserMainBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.03),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorMainPage()));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/image/BackButton.jpg',
                                    width: screenWidth * 0.08,
                                    height: screenWidth * 0.08,
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    'Back',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.20,
                                  height: screenWidth * 0.20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/image/Profile_icon.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorSetShopPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.015,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Set Shop',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: screenHeight * 0.05, thickness: 2, color: Colors.black),
                            SizedBox(height: screenHeight * 0.02),
                            _buildInfoRow('Email', 'JohnWick@gmail.com', screenWidth),
                            SizedBox(height: screenHeight * 0.02),
                            _buildInfoRow('Shop Name', 'The Alley', screenWidth),
                            SizedBox(height: screenHeight * 0.02),
                            _buildInfoRow('Pick Up Address', 'IEB', screenWidth),
                            Divider(height: screenHeight * 0.05, thickness: 1, color: Colors.black),
                            _buildPasswordRow(screenWidth),
                            Divider(height: screenHeight * 0.05, thickness: 1, color: Colors.black),
                            _buildPinRow(screenWidth),
                            SizedBox(height: screenHeight * 0.05),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: value,
            hintStyle: TextStyle(fontSize: screenWidth * 0.04),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRow(double screenWidth) {
    bool obscureText = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              obscureText: obscureText,
              controller: TextEditingController(text: "actualpassword"),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => obscureText = !obscureText),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPinRow(double screenWidth) {
    String pin = '';
    bool obscureText = true;
    bool isEditing = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('6-Digit PIN', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (!isEditing && pin.isEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() => isEditing = true);
                  _showPinDialog(context, (enteredPin) {
                    setState(() {
                      pin = enteredPin;
                      isEditing = false;
                    });
                  });
                },
                child: const Text('Set PIN'),
              )
            else if (!isEditing)
              TextField(
                readOnly: true,
                obscureText: obscureText,
                controller: TextEditingController(text: pin),
                decoration: InputDecoration(
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscureText = !obscureText),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() => isEditing = true);
                          _showPinDialog(context, (enteredPin) {
                            setState(() {
                              pin = enteredPin;
                              isEditing = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            else
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter 6-digit PIN',
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.length == 6) {
                    setState(() {
                      pin = value;
                      isEditing = false;
                    });
                  }
                },
              ),
          ],
        );
      },
    );
  }

  void _showPinDialog(BuildContext context, Function(String) onPinEntered) {
    String enteredPin = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter 6-Digit PIN'),
          content: TextField(
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            onChanged: (value) {
              enteredPin = value;
            },
            decoration: const InputDecoration(hintText: '000000'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (enteredPin.length == 6) {
                  onPinEntered(enteredPin);
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

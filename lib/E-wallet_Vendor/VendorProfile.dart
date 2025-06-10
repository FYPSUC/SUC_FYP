import 'package:flutter/material.dart';
import 'VendorMain.dart';
import 'VendorSetShop.dart';

class VendorProfilePage extends StatelessWidget {
  const VendorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VendorMainPage()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Important to prevent row from expanding
                          children: [
                            Image.asset(
                              'assets/image/BackButton.jpg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8), // Add some spacing between icon and text
                            const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Profile picture and username with Set Shop button
                  // 替代方案：按钮在用户名右侧
                  Row(
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/image/Profile_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(), // 添加空间
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VendorSetShopPage()),
                          );
                        },
                        child: const Text('Set Shop'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 40, thickness: 2, color: Colors.black),
                  const SizedBox(height: 20),

                  // Email (read-only)
                  _buildInfoRow('Email', 'JohnWick@gmail.com'),
                  const SizedBox(height: 20),

                  // Shop Name
                  _buildInfoRow('Shop Name', 'The Alley'),
                  const SizedBox(height: 20),

                  // Pick Up Address
                  _buildInfoRow('Pick Up Address', 'IEB'),
                  const SizedBox(height: 20),

                  const Divider(height: 40, thickness: 1, color: Colors.black),

                  // Password (read-only with visibility toggle)
                  _buildPasswordRow(),
                  const SizedBox(height: 20),

                  const Divider(height: 40, thickness: 1, color: Colors.black),

                  // 6-Digit PIN (editable)
                  _buildPinRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: value,
            hintStyle: TextStyle(color: Colors.black, fontSize: 17),
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

  Widget _buildPasswordRow() {
    bool obscureText = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Password', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              readOnly: true,
              obscureText: obscureText,
              controller: TextEditingController(text: "actualpassword"),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => obscureText = !obscureText),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      },
    );
  }


  Widget _buildPinRow() {
    String pin = '';
    bool obscureText = true;
    bool isEditing = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('6-Digit pin', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey[200],
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey[200],
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
            decoration: const InputDecoration(
              hintText: '000000',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
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
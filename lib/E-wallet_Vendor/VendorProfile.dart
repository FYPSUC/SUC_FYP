import 'package:flutter/material.dart';
import 'VendorMain.dart';
import 'VendorSetShop.dart';

class VendorProfilePage extends StatelessWidget {
  const VendorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
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
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const VendorMainPage()),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/image/BackButton.jpg',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 8),
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
                            Row(
                              children: [
                                Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/image/Profile_icon.png'),
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
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const VendorSetShopPage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Set Shop',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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

                            // 6-Digit PIN (editable) - 修正标题拼写错误
                            _buildPinRow(),

                            // 添加底部间距
                            const SizedBox(height: 40),
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

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
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
            // 修正拼写错误：6-Digit pin (原为6-Dinit nin)
            const Text(
              '6-Digit PIN', // 修正后的标题
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                      // 眼睛图标 - 点击切换显示/隐藏PIN
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
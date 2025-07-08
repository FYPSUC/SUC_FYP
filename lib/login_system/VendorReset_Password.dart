import 'package:flutter/material.dart';
import 'package:suc_fyp/main.dart';
import 'api_service.dart';

class VendorResetPasswordPage extends StatefulWidget {
  const VendorResetPasswordPage({super.key});

  @override
  State<VendorResetPasswordPage> createState() => _VendorResetPasswordPageState();
}

class _VendorResetPasswordPageState extends State<VendorResetPasswordPage> {

  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();


  String? _gmailError;
  String? _passwordError;
  String? _rePasswordError;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();

    _gmailController.addListener(_validateGmail);
    _passwordController.addListener(_validatePassword);
    _rePasswordController.addListener(_validateRePassword);
  }


  void _validateGmail() {
    final gmail = _gmailController.text.trim();
    final gmailReg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$', caseSensitive: false);

    setState(() {
      if (gmail.isEmpty) {
        _gmailError = "Gmail can't be empty";
      } else if (!gmailReg.hasMatch(gmail)) {
        _gmailError = "Please enter a valid Gmail address";
      } else {
        _gmailError = null;
      }
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = "Password can't be empty";
      } else if (password.length < 6) {
        _passwordError = "Password must be at least 6 characters";
      } else {
        _passwordError = null;
      }
    });
    _validateRePassword(); // 保证再次校验
  }

  void _validateRePassword() {
    final password = _passwordController.text;
    final rePassword = _rePasswordController.text;
    setState(() {
      if (rePassword.isEmpty) {
        _rePasswordError = "Please re-enter your password";
      } else if (password != rePassword) {
        _rePasswordError = "Passwords do not match";
      } else {
        _rePasswordError = null;
      }
    });
  }

  Future<void> sendResetRequest() async {
    final email = _gmailController.text.trim();
    final newPassword = _passwordController.text.trim();

    final result = await ApiService.sendVendorResetOtp(email, newPassword);
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your Gmail to complete reset.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${result['message']}')),
      );
    }

  }

  InputDecoration buildInputDecoration(String hint, IconData icon, String? errorText) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: Icon(icon, color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: errorText == null ? Colors.black : Colors.red, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: errorText == null ? Colors.black : Colors.red, width: 2),
      ),
      errorText: _showErrors ? errorText : null,
    );
  }

  TextStyle inputTextStyle() {
    return const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildInputField(
      TextEditingController controller,
      String hint,
      IconData icon, {
        bool obscure = false,
        TextInputType keyboard = TextInputType.text,
        String? errorText,
      }) {
    return SizedBox(
      width: 280,
      height: 55,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: inputTextStyle(),
        textAlignVertical: TextAlignVertical.center,
        decoration: buildInputDecoration(hint, icon, errorText),
      ),
    );
  }

  void _validateAndSubmit() {
    setState(() {
      _showErrors = true;
      _validateGmail();
      _validatePassword();
      _validateRePassword();
    });

    if (_gmailError == null &&
        _passwordError == null &&
        _rePasswordError == null) {
      sendResetRequest(); // 调用发送请求函数
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors before proceeding.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 19, top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      child: Image.asset(
                        'assets/image/BackButton.jpg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/image/sucE-wallet_icon.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                _buildInputField(_gmailController, "Gmail", Icons.email,
                    keyboard: TextInputType.emailAddress, errorText: _gmailError),
                const SizedBox(height: 30),
                _buildInputField(_passwordController, "Password", Icons.lock,
                    obscure: true, errorText: _passwordError),
                const SizedBox(height: 30),
                _buildInputField(_rePasswordController, "Re-Enter Password", Icons.lock_outline,
                    obscure: true, errorText: _rePasswordError),
                const SizedBox(height: 30),
                SizedBox(
                  width: 330,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: const BorderSide(color: Colors.black, width: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Vendor Reset Password',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

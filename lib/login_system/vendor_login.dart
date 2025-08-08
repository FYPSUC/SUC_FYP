import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:suc_fyp/E-wallet_Vendor/VendorMain.dart';
import 'package:suc_fyp/login_system/login.dart';
import 'package:suc_fyp/login_system/register.dart';
import 'package:suc_fyp/login_system/VendorReset_Password.dart';
import 'package:suc_fyp/main.dart';

class VendorLoginPage extends StatefulWidget {
  const VendorLoginPage({super.key});

  @override
  State<VendorLoginPage> createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginVendor() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // ✅ Step 1: Firebase 登录
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;

      // ✅ Step 2: 用 UID 从 MySQL 检查是否是 Vendor
      final result = await ApiService.getVendorByUID(uid!);
      print("👀 API 回传: $result");

      if (result['success'] == true && result['user']['role'] == 'Vendor') {
        // ✅ Step 3: 保存 UID 和角色到本地
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        await prefs.setString('role', 'Vendor');

        // ✅ Step 4: 进入 Vendor 主页
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VendorMainPage()),
        );
      } else {
        showError("This account is not registered as a Vendor.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'Email not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      }
      showError(errorMessage);
    } catch (e) {
      showError("Unexpected error: $e");
    }
  }



  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
    child: LayoutBuilder(
    builder: (context, constraints) {
    return SingleChildScrollView(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: ConstrainedBox(
    constraints: BoxConstraints(minHeight: constraints.maxHeight),
    child: IntrinsicHeight(
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    const SizedBox(height: 20),
    Padding(
    padding: const EdgeInsets.only(left: 19),
    child: Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
    onTap: () {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => const HomePage()));
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
    Center(
    child: Image.asset(
    'assets/image/SUCE-wallet_icon.png',
    width: 300,
    height: 300,
    fit: BoxFit.contain,
    ),
    ),
    const Text(
    'Vendor Login',
    style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    ),
    ),
    const SizedBox(height: 30),

    // Email
    SizedBox(
    width: 280,
    height: 55,
    child: TextFormField(
    controller: emailController,
    style: const TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
    hintText: 'Email',
    hintStyle: const TextStyle(color: Colors.black54),
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    prefixIcon: const Padding(
    padding: EdgeInsets.only(left: 15, right: 10),
    child: Icon(Icons.email, color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your username';
    }
    return null;
    },
    ),
    ),
    const SizedBox(height: 30),

    // Password
    SizedBox(
    width: 280,
    height: 55,
    child: TextFormField(
    controller: passwordController,
    obscureText: true,
    style: const TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
    hintText: 'Password',
    hintStyle: const TextStyle(color: Colors.black54),
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    prefixIcon: const Padding(
    padding: EdgeInsets.only(left: 15, right: 10),
    child: Icon(Icons.lock, color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your password';
    } else if (value.length < 6) {
    return 'Password must be at least 6 characters';
    }
    return null;
    },
    ),
    ),
    const SizedBox(height: 16),

    // Login as user
    Align(
    alignment: Alignment.centerLeft,
    child: Padding(
    padding: const EdgeInsets.only(left: 20),
    child: GestureDetector(
    onTap: () {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => const LoginPage()));
    },
    child: const Text(
    'Log in as user',
    style: TextStyle(
    fontSize: 20,
    color: Colors.indigo,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    ),
    const SizedBox(height: 30),

    // Login button
    SizedBox(
    width: 220,
    height: 80,
    child: ElevatedButton(
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    loginVendor();
    }
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    elevation: 0,
    side: const BorderSide(color: Colors.black, width: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: const Text(
    'Log in',
    style: TextStyle(
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    const SizedBox(height: 20),

    // Register / Forgot
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    },
    child: const Text(
    'Create an account',
    style: TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    const SizedBox(width: 10),
    const Text("|", style: TextStyle(fontSize: 18)),
    const SizedBox(width: 10),
    GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const VendorResetPasswordPage()),
    );
    },
    child: const Text(
    'Forget Password?',
    style: TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 30),
    ],
    ),
    ),
    ),
    ),
    );
    },
    ),
        ),
      ),
    );
  }
}

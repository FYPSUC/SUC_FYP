  import 'package:flutter/material.dart';
  import 'package:suc_fyp/main.dart';
  import 'login.dart';
  import 'vendor_login.dart';
  import 'api_service.dart'; // 导入API服务
  import 'dart:convert';
  import 'package:firebase_auth/firebase_auth.dart';

  class RegisterPage extends StatefulWidget {
    final String initialRole; // User or Vendor

    const RegisterPage({super.key, this.initialRole = 'User'});

    @override
    State<RegisterPage> createState() => _RegisterPageState();
  }

  class _RegisterPageState extends State<RegisterPage> {
    late String selectedRole;
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();

    String? _usernameError;
    String? _passwordError;
    String? _emailError;

    @override
    void initState() {
      super.initState();
      selectedRole = widget.initialRole;
    }

    @override
    void dispose() {
      _usernameController.dispose();
      _passwordController.dispose();
      _emailController.dispose();
      super.dispose();
    }

    void _validateUsername(String value) {
      final valid = RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value);
      setState(() {
        _usernameError = valid ? null : 'Symbols are not allowed';
      });
    }

    void _validateEmail(String value) {
      final emailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value);
      setState(() {
        _emailError = emailValid ? null : 'Please enter a valid email address';
      });
    }

    /// ✅ 改为 Future<void>，允许使用 await
    Future<void> _validateFields() async {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      final email = _emailController.text.trim();

      List<String> missingFields = [];

      if (username.isEmpty) missingFields.add('Username');
      if (password.isEmpty) missingFields.add('Password');
      if (email.isEmpty) missingFields.add('Email');

      setState(() {
        _usernameError = username.isEmpty ? 'Username is required' : _usernameError;
        _passwordError = password.isEmpty
            ? 'Password is required'
            : (password.length < 6 ? 'Password must be at least 6 characters' : null);
        _emailError = email.isEmpty ? 'Email is required' : _emailError;
      });

      if (email.isNotEmpty) {
        _validateEmail(email);
      }

      if (missingFields.isNotEmpty) {
        String errorMessage = '${missingFields.join(', ')} ${missingFields.length == 1 ? 'is' : 'are'} required';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        return;
      }

      if (_usernameError != null || _passwordError != null || _emailError != null) {
        return;
      }

      try {
        // ✅ 第一步：使用 Firebase 进行注册
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final firebaseUser = credential.user;
        if (firebaseUser != null) {
          final uid = firebaseUser.uid;

          // ✅ 第二步：将数据存入你的 MySQL 数据库
          final result = await ApiService.registerUser(firebaseUser.uid, _usernameController.text.trim(), _emailController.text.trim(), selectedRole, // 'User' or 'Vendor'
          );

          if (result['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful')),
            );
            if (selectedRole == 'User') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VendorLoginPage()));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Registration failed')),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registration failed';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email already in use';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email format';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password is too weak';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Image.asset('assets/image/sucE-wallet_icon.png', width: 300, height: 300, fit: BoxFit.contain),
                      Text(
                        '$selectedRole Register',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 110.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 1.5,
                              child: TextField(
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: const TextStyle(color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15, right: 10),
                                    child: Icon(Icons.person, color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(color: _usernameError == null ? Colors.black : Colors.red, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(color: _usernameError == null ? Colors.black : Colors.red, width: 2),
                                  ),
                                  errorText: _usernameError,
                                ),
                                onChanged: _validateUsername,
                              ),
                            ),
                            const SizedBox(height: 10),
                            FractionallySizedBox(
                              widthFactor: 1.5,
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                onChanged: (value) {
                                  if (value.isNotEmpty && value.length < 6) {
                                    setState(() {
                                      _passwordError = 'Password must be at least 6 characters';
                                    });
                                  } else {
                                    setState(() {
                                      _passwordError = null;
                                    });
                                  }
                                },
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
                                    borderSide: BorderSide(color: _passwordError == null ? Colors.black : Colors.red, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(color: _passwordError == null ? Colors.black : Colors.red, width: 2),
                                  ),
                                  errorText: _passwordError,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FractionallySizedBox(
                              widthFactor: 1.5,
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
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
                                    borderSide: BorderSide(color: _emailError == null ? Colors.black : Colors.red, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(color: _emailError == null ? Colors.black : Colors.red, width: 2),
                                  ),
                                  errorText: _emailError,
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _validateEmail(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () => setState(() => selectedRole = 'User'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedRole == 'User' ? Colors.black : Colors.black.withOpacity(0.5),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
                                ),
                              ),
                              child: Text(
                                'User',
                                style: TextStyle(fontSize: 25, color: Colors.white.withOpacity(selectedRole == 'User' ? 1.0 : 0.6)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            width: 150,
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () => setState(() => selectedRole = 'Vendor'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedRole == 'Vendor' ? Colors.black : Colors.black.withOpacity(0.5),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40)),
                                ),
                              ),
                              child: Text(
                                'Vendor',
                                style: TextStyle(fontSize: 25, color: Colors.white.withOpacity(selectedRole == 'Vendor' ? 1.0 : 0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 330,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _validateFields(); // ✅ 现在合法
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            side: const BorderSide(color: Colors.black, width: 3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Positioned(
                  left: 19,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                    },
                    child: Image.asset('assets/image/BackButton.jpg', width: 40, height: 40, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

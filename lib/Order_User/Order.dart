import 'package:flutter/material.dart';

class UserOrderPage extends StatelessWidget {
  const UserOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Page')),
      body: const Center(
        child: Text('Welcome to Order Page'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class UserClinicPage extends StatelessWidget {
  const UserClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinic Page')),
      body: const Center(
        child: Text('Welcome to Clinic Page'),
      ),
    );
  }
}
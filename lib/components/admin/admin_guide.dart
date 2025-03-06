import 'package:flutter/material.dart';

class Admin_Guide extends StatelessWidget {
  const Admin_Guide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recycling Guide',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff4CAF50),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
      ),
      body: const Center(
        child: Text('Admin Guide Content Coming Soon',
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

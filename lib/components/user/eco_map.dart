import 'package:flutter/material.dart';

class eco_map extends StatelessWidget {
  const eco_map({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recycling Locations',
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
        child: Text('Map Content Coming Soon', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

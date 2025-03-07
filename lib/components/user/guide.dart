import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Guide extends StatelessWidget {
  const Guide({super.key});

  Widget _buildGuideRow(BuildContext context, String animation, String title,
      String description, bool isReversed) {
    final screenWidth = MediaQuery.of(context).size.width;
    final rowChildren = [
      // Animation container
      Expanded(
        flex: 1,
        child: Lottie.asset(
          animation,
          height: screenWidth * 0.4,
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(width: screenWidth * 0.05),
      // Text container
      Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment:
              isReversed ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xff388E3C),
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
              textAlign: isReversed ? TextAlign.left : TextAlign.right,
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              description,
              style: TextStyle(
                color: Colors.black87,
                fontSize: screenWidth * 0.04,
              ),
              textAlign: isReversed ? TextAlign.left : TextAlign.right,
            ),
          ],
        ),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenWidth * 0.04,
      ),
      child: Row(
        children: isReversed ? rowChildren.reversed.toList() : rowChildren,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Text(
                "How to Use EcoBin",
                style: TextStyle(
                  color: const Color(0xff388E3C),
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildGuideRow(
              context,
              'assets/land.json',
              "Step 1: Sort Your Waste",
              "Separate your waste into biodegradable and non-biodegradable materials. Biodegradable waste includes food scraps, leaves, and paper.",
              false,
            ),
            Divider(
              color: const Color(0xff388E3C).withOpacity(0.2),
              thickness: 1,
              indent: screenWidth * 0.06,
              endIndent: screenWidth * 0.06,
            ),
            _buildGuideRow(
              context,
              'assets/drop.json',
              "Step 2: Find Drop Points",
              "Use the map feature to locate the nearest biodegradable waste collection points in your area.",
              true,
            ),
            Divider(
              color: const Color(0xff388E3C).withOpacity(0.2),
              thickness: 1,
              indent: screenWidth * 0.06,
              endIndent: screenWidth * 0.06,
            ),
            _buildGuideRow(
              context,
              'assets/trash.json',
              "Step 3: Dispose Properly",
              "Drop off your biodegradable waste at the designated collection points. Help create a cleaner, greener environment!",
              false,
            ),
            Divider(
              color: const Color(0xff388E3C).withOpacity(0.2),
              thickness: 1,
              indent: screenWidth * 0.06,
              endIndent: screenWidth * 0.06,
            ),
            _buildGuideRow(
              context,
              'assets/update.json',
              "Step 4: Stay Updated",
              "Keep checking the app regularly for new drop points in your area. We're constantly expanding our network of collection points!",
              true,
            ),
            Divider(
              color: const Color(0xff388E3C).withOpacity(0.2),
              thickness: 1,
              indent: screenWidth * 0.06,
              endIndent: screenWidth * 0.06,
            ),
            _buildGuideRow(
              context,
              'assets/share.json',
              "Step 5: Spread the Word",
              "Share EcoBin with your friends and family. Together, we can make a bigger impact on waste management and environmental conservation!",
              false,
            ),
          ],
        ),
      ),
    );
  }
}

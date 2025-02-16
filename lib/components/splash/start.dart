import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../login/login.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xff4CAF50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "-- EcoBin --",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.15), // Add margin to push right
                child: Lottie.asset(
                  'assets/world.json',
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.9,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  "Join us in making waste management smarter! Sort, Track, and Dispose Biodegradables Responsibly.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenWidth * 0.08),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenSize.height * 0.02,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff388E3C),
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: Text(
                    'Start !',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

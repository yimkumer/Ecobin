import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:masters_final_app/components/user/home_user.dart';

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - (size.height * 0.10));
    path.lineTo(size.width, size.height - (size.height * 0.10));
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Walkthrough extends StatelessWidget {
  final PageController controller = PageController();
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  Walkthrough({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (page) {
              currentPage.value = page;
            },
            children: [
              _buildPage(
                screenSize,
                DiagonalClipper(),
                'assets/ppl.json',
                "Welcome to EcoBin",
                "Your Smart Waste Management Solution",
              ),
              _buildPage(
                screenSize,
                DiagonalClipper(),
                'assets/ppl.json',
                "Sort Your Waste",
                "Learn to separate biodegradable and non-biodegradable waste",
              ),
              _buildPage(
                screenSize,
                DiagonalClipper(),
                'assets/ppl.json',
                "Track & Monitor",
                "Keep track of your waste disposal patterns",
              ),
              _buildPage(
                screenSize,
                DiagonalClipper(),
                'assets/ppl.json',
                "Make a Difference",
                "Join us in creating a sustainable future through proper waste management",
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.02,
            right: screenWidth * 0.02,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home_user()),
                );
              },
              child: const Text(
                "SKIP",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: currentPage,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: value >= index
                                ? const Color(0xff4CAF50)
                                : const Color(0xffD9D9D9),
                          ),
                        );
                      }),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.04),
                ValueListenableBuilder<int>(
                  valueListenable: currentPage,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: () {
                        if (value < 3) {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home_user()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff4CAF50),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: screenWidth * 0.03,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        value < 3 ? "NEXT" : "GET STARTED",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Size screenSize, CustomClipper<Path> clipper,
      String animation, String title, String description) {
    return Stack(
      children: [
        Container(
          color: const Color(0xff4CAF50),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: clipper,
            child: Container(
              height: screenSize.height * 0.9,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: screenSize.height * 0.15,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                animation,
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.35,
                fit: BoxFit.contain,
              ),
              SizedBox(height: screenSize.height * 0.03),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: screenSize.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenSize.height * 0.015),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenSize.width * 0.045,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

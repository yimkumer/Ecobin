import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:masters_final_app/components/admin/admin_map.dart';
import '../login/login.dart';
import 'admin_view.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildFeatureCard(
      String title, String description, String animation, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 6,
          shadowColor: Colors.green.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xff388E3C).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenWidth * 0.08,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenWidth * 0.45,
                  child: Lottie.asset(
                    animation,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff388E3C),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: _handleLogout,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "Welcome Back, Admin!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Lottie.asset(
                    'assets/wave.json',
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.4,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "Manage EcoBin Locations",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: screenWidth * 0.05,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.1),
                      topRight: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Column(
                        children: [
                          Text(
                            "Admin Controls",
                            style: TextStyle(
                              color: const Color(0xff388E3C),
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.06),
                          _buildFeatureCard(
                            "View Users",
                            "See all registered users",
                            'assets/list.json',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const admin_view(),
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.04),
                          _buildFeatureCard(
                            "Manage Locations",
                            "Update recycling points",
                            'assets/map.json',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const admin_map(),
                              ),
                            ),
                          ),
                        ],
                      ),
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

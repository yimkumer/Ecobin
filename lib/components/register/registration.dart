import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../login/login.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user in Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Format current date as DD/MM/YY
      DateTime now = DateTime.now();
      String formattedDate = "${now.day.toString().padLeft(2, '0')}/"
          "${now.month.toString().padLeft(2, '0')}/"
          "${now.year.toString().substring(2)}";

      // Save user details in Realtime Database
      await FirebaseDatabase.instance.ref().child('users').push().set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'createdAt': formattedDate,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'weak-password':
          message = 'Password should be at least 6 characters';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email';
          break;
        default:
          message = 'Registration failed. Please try again.';
          print('Firebase Auth Error: ${e.code}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } on FirebaseException catch (e) {
      print('Firebase Database Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database Error: ${e.message}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Unexpected error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff4CAF50),
            ),
            child: Column(
              children: [
                SizedBox(height: screenWidth * 0.04),
                Text(
                  "Register for EcoBin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Lottie.asset(
                  'assets/registration.json',
                  height: screenWidth * 0.55,
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
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.08),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.person,
                                      color: Color(0xff388E3C)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenWidth * 0.05),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color(0xff388E3C)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenWidth * 0.05),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Color(0xff388E3C)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xff388E3C),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenWidth * 0.05),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Color(0xff388E3C)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xff388E3C),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible =
                                            !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenWidth * 0.08),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xff388E3C),
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenWidth * 0.04),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _handleRegistration,
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                },
                                child: Text(
                                  'Already have an account? Login',
                                  style: TextStyle(
                                    color: const Color(0xff388E3C),
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

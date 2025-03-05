import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:masters_final_app/components/admin/admin.dart';
import 'package:masters_final_app/components/register/registration.dart';
import 'package:masters_final_app/components/user/walkthrough.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      FirebaseAuth.instance.setLanguageCode('en');
      await FirebaseAuth.instance.fetchSignInMethodsForEmail('test@test.com');
      if (mounted) {
        setState(() {
          _isFirebaseInitialized = true;
        });
      }
    } catch (e) {
      print('Firebase Connection Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to connect to Firebase. Please check your internet connection.'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isFirebaseInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Firebase connection not established. Please wait or check your internet.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Attempt to sign in with email and password
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;

      if (email == 'admin@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Admin()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Walkthrough()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');

      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = 'An error occurred. Please try again.';
          print('Unexpected error: ${e.code}');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff4CAF50),
            ),
            child: Column(
              children: [
                SizedBox(height: screenWidth * 0.1),
                Text(
                  "Welcome to EcoBin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
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
                              Lottie.asset(
                                'assets/login.json',
                                width: screenWidth * 0.7,
                                height: screenWidth * 0.65,
                                fit: BoxFit.contain,
                              ),
                              TextFormField(
                                controller: _emailController,
                                enabled: _isFirebaseInitialized,
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
                                enabled: _isFirebaseInitialized,
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
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenWidth * 0.02),
                              TextButton(
                                onPressed: _isFirebaseInitialized
                                    ? () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Registration(),
                                          ),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  'New User? Register now',
                                  style: TextStyle(
                                    color: _isFirebaseInitialized
                                        ? const Color(0xff388E3C)
                                        : Colors.grey,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth * 0.08),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xff388E3C),
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenWidth * 0.04,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed:
                                      (_isLoading || !_isFirebaseInitialized)
                                          ? null
                                          : _handleLogin,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Color(0xff388E3C),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

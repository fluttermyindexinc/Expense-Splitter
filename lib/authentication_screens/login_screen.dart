import 'package:expense_splitter/authentication_screens/registration_screen.dart';
import 'package:expense_splitter/view/screens/main_nav_screens.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This property prevents the Scaffold's body from resizing when the keyboard appears.
      // The background will now remain fixed, and the SingleChildScrollView will handle scrolling.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/authentication_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // UI Elements wrapped in a SingleChildScrollView
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 140.0),

                    // App Logo
                    Image.asset(
                      'assets/images/logo_header.png',
                      height: 80,
                    ),

                    const SizedBox(height: 48.0),

                    // Email or Username Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Email or Username',
                          prefixIcon: const Icon(Icons.person_outline),
                          // Remove the default border to rely on the container's decoration
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                        ),
                      ),
                    ),


                    const SizedBox(height: 16.0),

                    // Password Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: const Icon(Icons.visibility_off_outlined),
                          // Remove the default border
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10.0),

                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password functionality
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
                       
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          
                        ),
                        backgroundColor: Colors.red[900],
                        elevation: 4,
                      ),
                      child: const Text('Login',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),

                    const SizedBox(height: 40.0),

                    // "Or login with" text
                    const Text(
                      'Or login with',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),

                    const SizedBox(height: 16.0),

                    // Google and Register Now Buttons
                    Row(
                      children: [
                        // Google Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement Google login
                            },
                            icon: Image.asset('assets/images/google_logo.png',
                                height: 24),
                            label: const Text('Google'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16.0),

                        // Register Now Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                               Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Register Now'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF1A237E),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

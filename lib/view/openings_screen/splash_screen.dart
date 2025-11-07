import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the services and models
import 'package:expense_splitter/api/check_user_details.api.dart';
import 'package:expense_splitter/model/check_user_details.dart';

// Import your destination screens
import 'package:expense_splitter/authenticaton_screen/login_page.dart';
import 'package:expense_splitter/view/screens/main_nav_screens.dart';
import 'onboarding_carousel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CheckUserApiService _checkuserApiService = CheckUserApiService();

  @override
  void initState() {
    super.initState();
    _checkStatusAndNavigate();
  }


  // Future<void> _showBannedUserDialog() async {
  //   if (!mounted) return;

  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // User must interact with the dialog
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         title: const Row(
  //           children: [
  //             Icon(Icons.gpp_bad, color: Colors.red), // Alert icon
  //             SizedBox(width: 10),
  //             Text('Access Denied'),
  //           ],
  //         ),
  //         content: const SingleChildScrollView(
  //           child: Text(
  //             'Your account has been restricted.\nPlease contact support for assistance.',
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(dialogContext).pop(); // Closes the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _showBannedUserDialog() async {
  if (!mounted) return;

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must interact with the dialog
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/change-modified-alert-bg.jpg', 
                fit: BoxFit.cover,
                height: 250,
                width: 320,
              ),
            ),

            // Content layered on top
            Container(
              height: 250,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black.withOpacity(0.4), // Dark overlay for readability
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Title
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.gpp_bad, color: Colors.red, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'Access Denied',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Content
                    const Text(
                      'Your account has been restricted.\nPlease contact support for assistance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Spacer(),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Closes the dialog
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

  void _checkStatusAndNavigate() {
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      try {
        final prefs = await SharedPreferences.getInstance();

        // 1. Onboarding Check
        if (!(prefs.getBool('onboarding_completed') ?? false)) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingCarousel()),
          );
          return;
        }

        // 2. Login Status Check
        if (!(prefs.getBool('isLoggedIn') ?? false)) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
          return;
        }

        // 3. API Status Verification for Logged-In Users
        final int? userId = prefs.getInt('userId');
        final String? token = prefs.getString('token');

        if (userId == null) { // Token might be optional depending on your API auth
          throw Exception("User ID not found, forcing logout.");
        }

        final CheckUserDetails checkUserDetails = await _checkuserApiService.fetchUserDetails(
          token: token ?? '', // Pass the user's session token or an empty string
          userId: userId,
        );

        // --- UPDATED LOGIC ---
        // 4. Navigate based on the fresh API status
        if (checkUserDetails.isBanned == 0) { // Status 0: Active
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          }
        } else { // Status 1 (Banned) or 2 (Unverified)
          // If not active, show the access denied dialog first
          await _showBannedUserDialog();
          
          // After the user dismisses the dialog, clear their data and log them out
          await prefs.clear();
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        }
      } catch (e) {
        // This catch block handles all errors, including API failures or missing data
        print("Error during splash screen check: $e. Forcing logout.");
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png', // Your logo
            width: 560,
            height: 240,
          ),
        ),
      ),
    );
  }
}

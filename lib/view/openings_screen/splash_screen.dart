import 'dart:async';
import 'package:expense_splitter/Dummy/login_page.dart';
// import 'package:expense_splitter/authentication_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_carousel.dart'; // Your onboarding screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnOnboardingStatus();
  }

  void _navigateBasedOnOnboardingStatus() {
    // Wait for 3 seconds to show the splash screen.
    Timer(const Duration(seconds: 3), () async {
      // Check if the widget is still mounted before navigating.
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      // Check if the 'onboarding_completed' flag is true. Default to false if not set.
      final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

      if (onboardingCompleted) {
        // If onboarding is done, go directly to the NextPage.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        // If it's the first time, show the onboarding carousel.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingCarousel()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: Center(
          // Your logo or splash screen content.
          child: Image.asset(
            'assets/images/logo.png', // Ensure you have this asset.
            width: 560,
            height: 240,
          ),
        ),
      ),
    );
  }
}

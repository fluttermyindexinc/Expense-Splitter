

// lib/screens/verify_otp_registration.dart

import 'dart:async';
import 'package:expense_splitter/authenticaton_screen/login_page.dart';
import 'package:expense_splitter/model/auth_models.dart';
import 'package:expense_splitter/utils/session_manager.dart';
import 'package:expense_splitter/view/screens/main_nav_screens.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_api_service.dart';

class VerifyOtpRegistration extends StatefulWidget {
  final int userId;
  final String phoneNumber;
  const VerifyOtpRegistration({
    super.key,
    required this.userId,
    required this.phoneNumber,
  });

  @override
  State<VerifyOtpRegistration> createState() => _VerifyOtpRegistrationState();
}

class _VerifyOtpRegistrationState extends State<VerifyOtpRegistration> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  final AuthApiService _apiService = AuthApiService();
  late Timer _timer;
  int _start = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() => _isResendEnabled = false);
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_start == 0) {
        setState(() => _isResendEnabled = true);
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true); // Optional: show loading state
    try {
      await _apiService.resendOtp(userId: widget.userId);
      _showSuccessSnackBar('A new OTP has been sent.');
      startTimer(); // Restart the countdown
    } catch (e) {
      _showErrorSnackBar('Failed to resend OTP. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

// Future<void> _saveUserData(User user) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('isLoggedIn', true);
//   await prefs.setInt('userId', user.id);
//   await prefs.setString('name', user.name);
  
//   // FIX: Safely handle the nullable email.
//   await prefs.setString('email', user.email ?? '');
  
//   // FIX: user.mobile is now correctly a String, so this works.
//   await prefs.setString('mobile', user.mobile); 
  
//   await prefs.setInt('is_banned', user.is_banned);
//   await prefs.setString('username', user.username);
//   await prefs.setString('dp', user.dp ?? 'user.png');
// }

//   Future<void> _verifyOtp() async {
//   if (_otpController.text.length != 6) {
//     _showErrorSnackBar('Please enter a valid 6-digit OTP.');
//     return;
//   }

//   setState(() => _isLoading = true);

//   try {
//     final response = await _apiService.verifyOtp(
//       userId: widget.userId,
//       otp: _otpController.text,
//     );

//     if (response.status == 200 && response.user != null) {
//       final User user = response.user; // It's already a User object!
//       final int userStatus = user.is_banned; // Access with dot notation.

//       await _saveUserData(user);

//       switch (userStatus) {
//         case 0: // Active User
//           _showSuccessSnackBar("Welcome! You're successfully logged in.");
//           await Future.delayed(const Duration(seconds: 2));
//           if (mounted) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const MainScreen()),
//               (route) => false,
//             );
//           }
//           break;

//         case 1: // Banned User
//         case 2: // Unverified User
//           String message = userStatus == 1
//               ? 'Your account has been banned. Please contact support.'
//               : 'Your account is pending verification. Please wait.';
//           _showErrorSnackBar(message);
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.clear(); // Clear the session
//           await Future.delayed(const Duration(seconds: 3));
//           if (mounted) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const LoginPage()),
//               (route) => false,
//             );
//           }
//           break;

//         default:
//           _showErrorSnackBar('An unknown user status was received.');
//           break;
//       }
//     } else {
//       final errorMessage = response.message?.isNotEmpty == true
//           ? response.message!
//           : "The OTP is incorrect or has expired.";
//       _showErrorSnackBar(errorMessage);
//     }
//   } catch (e) {
//     print('An exception occurred in _verifyOtp: $e');
//     _showErrorSnackBar('An error occurred. Please try again.');
//   } finally {
//     if (mounted) {
//       setState(() => _isLoading = false);
//     }
//   }
// }

  // void _showErrorSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.red),
  //   );
  // }


   Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      _showErrorSnackBar('Please enter a valid 6-digit OTP.');
      return;
    }
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.verifyOtp(
        userId: widget.userId,
        otp: _otpController.text,
      );

      if (mounted) {
        if (response.status == 200 && response.user != null) {
          final User user = response.user;
          final int userStatus = user.is_banned;

          switch (userStatus) {
            case 0: // Active User
              // --- THE FIX: Use the central SessionManager ---
              await SessionManager.saveUserData(user);

              _showSuccessSnackBar("Welcome! You're successfully registered.");
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              }
              break;

            case 1: // Banned User
            case 2: // Unverified User
              String message = userStatus == 1
                  ? 'Your account has been banned. Please contact support.'
                  : 'Your account is pending verification. Please wait.';
              _showErrorSnackBar(message);
              // Clear any partial data if login fails for non-active users
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await Future.delayed(const Duration(seconds: 3));
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
              break;

            default:
              _showErrorSnackBar('An unknown user status was received.');
              break;
          }
        } else {
          final errorMessage = response.message.isNotEmpty
              ? response.message
              : "The OTP is incorrect or has expired.";
          _showErrorSnackBar(errorMessage);
        }
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior
            .floating, // Makes it float above the bottom nav bar
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _maskPhoneNumber(String number) {
    if (number.length > 4) {
      return 'XXXXXX${number.substring(number.length - 4)}';
    }
    return number;
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/authentication_background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_header.png',
                    height: 220,
                    width: 280,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Please enter the OTP we've sent to\n",
                        ),
                        TextSpan(
                          text: _maskPhoneNumber(widget.phoneNumber),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Change?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: const Color(0xFF1A1E57)),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1E57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isResendEnabled
                      ? TextButton.icon(
                          onPressed: _isLoading
                              ? null
                              : _resendOtp, // Call the new method
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You can send OTP again in ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              '00:${_start.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:expense_splitter/api/auth_api_service.dart';
import 'package:expense_splitter/authenticaton_screen/login_page.dart';
import 'package:expense_splitter/model/auth_models.dart';
import 'package:expense_splitter/utils/session_manager.dart';

import 'package:expense_splitter/view/screens/main_nav_screens.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpLogin extends StatefulWidget {
  final int userId;
  final String phoneNumber;
  const VerifyOtpLogin({
    super.key,
    required this.phoneNumber,
    required this.userId,
  });

  @override
  State<VerifyOtpLogin> createState() => _VerifyOtpLoginState();
}

class _VerifyOtpLoginState extends State<VerifyOtpLogin> {
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
    _start = 60;
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
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

//   Future<void> _saveUserData(User user) async {
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

// Future<void> _saveUserData(User user) async {
//   final prefs = await SharedPreferences.getInstance();

//   await prefs.setBool('isLoggedIn', true);
//   await prefs.setInt('userId', user.id);
//   await prefs.setString('name', user.name);

//   // Safely handle nullable email
//   await prefs.setString('email', user.email ?? '');

//   // user.mobile is now a String
//   await prefs.setString('mobile', user.mobile);

//   await prefs.setInt('is_banned', user.is_banned);
//   await prefs.setString('username', user.username);
//   await prefs.setString('dp', user.dp ?? 'user.png');
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
              // --- THE FIX: Use the central SessionManager to save data ---
              await SessionManager.saveUserData(user);

              _showSuccessSnackBar("Welcome! You're successfully logged in.");
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
              // It's good practice to clear any partial data if login fails
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
      _showErrorSnackBar('Please enter a valid OTP.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

// Future<void> _verifyOtp() async {
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
//       final User user = response.user!;
//       final int userStatus = user.is_banned;

//       // --- THE FIX: Check the user's status BEFORE saving data ---
//       switch (userStatus) {
//         case 0: // Active User - This is the only case where we save and proceed
//           await _saveUserData(user); // Save data only for active users
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
          
//           // No need to clear prefs, as we never saved them for this user
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


  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.red,
        behavior:SnackBarBehavior.floating,
            // Makes it float above the bottom nav bar
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(fontWeight: FontWeight.bold),),
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

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   _otpController.dispose();
  //   super.dispose();
  // }

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
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),

      body: Stack(
        children: [
          // Background image layer:
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/authentication_background.jpg',
                ), // <-- Your image path here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Optional semi-transparent overlay:
          Container(color: Colors.black.withOpacity(0.3)),
          // Main OTP UI
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
                  const SizedBox(height: 30),
                  const Text(
                    'Please enter the OTP we\'ve sent to',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  // const SizedBox(height: 8),
                  Text(
                    _maskPhoneNumber(widget.phoneNumber),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Change?',

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1A1E57),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: const Color(0xFF1A1E57)),
                    ),
                    submittedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: Colors.green),
                    ),

                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) => print("Completed: $pin"),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1E57),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isResendEnabled
                      ? TextButton.icon(
                          onPressed: _isLoading ? null : _resendOtp, // Call the new method
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Resend OTP",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }
}

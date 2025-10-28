// // lib/screens/verify_otp_login.dart

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';

// class VerifyOtpRegistration extends StatefulWidget {
//   final String phoneNumber;
//   const VerifyOtpRegistration({super.key, required this.phoneNumber});

//   @override
//   State<VerifyOtpRegistration> createState() => _VerifyOtpRegistrationState();
// }

// class _VerifyOtpRegistrationState extends State<VerifyOtpRegistration> {
//   final TextEditingController _otpController = TextEditingController();
//   late Timer _timer;
//   int _start = 60;
//   bool _isResendEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     setState(() {
//       _isResendEnabled = false;
//       _start = 60;
//     });
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _isResendEnabled = true;
//           timer.cancel();
//         });
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }

//   String _maskPhoneNumber(String number) {
//     if (number.length > 4) {
//       return 'XXXXXX${number.substring(number.length - 4)}';
//     }
//     return number;
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//       ),
//     );

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/authentication_background.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(color: Colors.black.withOpacity(0.3)),

//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/logo_header.png', // Your logo
//                     height: 220,
//                     width: 280,
//                   ),

//                   // FIX: Text with different colors using RichText
//                   RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       style: const TextStyle(color: Color(0xFF1A1E57), fontSize: 16),
//                       children: <TextSpan>[
//                         const TextSpan(text: "Please enter the OTP we've sent to\n"),
//                         TextSpan(
//                           text: _maskPhoneNumber(widget.phoneNumber),
//                           style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // FIX: "Change?" button to go back
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       'Change?',
//                        style: TextStyle(
//                          color: Color(0xFF1A1E57),
//                          fontWeight: FontWeight.bold,
//                          decoration: TextDecoration.underline,
//                        ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   Pinput(
//                     length: 6,
//                     controller: _otpController,
//                     defaultPinTheme: defaultPinTheme,
//                     focusedPinTheme: defaultPinTheme.copyWith(
//                       decoration: defaultPinTheme.decoration!.copyWith(
//                         border: Border.all(color: const Color(0xFF1A1E57)),
//                       ),
//                     ),
//                     submittedPinTheme: defaultPinTheme.copyWith(
//                       decoration: defaultPinTheme.decoration!.copyWith(
//                         // color: Colors.grey.shade100,
//                       ),
//                     ),
//                     pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//                     showCursor: true,
//                     onCompleted: (pin) {
//                       print("Completed: $pin");
//                     },
//                   ),
//                   const SizedBox(height: 32),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1A1E57),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () {
//                         if (_otpController.text.length == 6) {
//                           print("Verifying OTP: ${_otpController.text}");
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please enter a valid 6-digit OTP'),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       child: const Text(
//                         'Continue',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   _isResendEnabled
//                       ? TextButton.icon(
//                           onPressed: startTimer,
//                           icon: const Icon(Icons.refresh, color: Color(0xFF1A1E57)),
//                           label: const Text(
//                             "Resend OTP",
//                             style: TextStyle(color: Color(0xFF1A1E57), fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       :
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//  Text(
//                           "You can send OTP again in ",
//                           style: const TextStyle(color: Color(0xFF1A1E57)),
//                         ),
//                         Text('00:${_start.toString().padLeft(2, '0')}',style: const TextStyle(color: Colors.white))
//                         ]

//                       )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/verify_otp_registration.dart

import 'dart:async';
import 'package:expense_splitter/view/screens/main_nav_screens.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
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

      //   if (response.status == 200) {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => const MainScreen()),
      //       (route) => false,
      //     );
      //   } else {
      //     _showErrorSnackBar(response.message);
      //   }
      // } catch (e) {
      //   _showErrorSnackBar('An error occurred: ${e.toString()}');
      // } finally {
      //   if (mounted) {
      //     setState(() => _isLoading = false);
      //   }
      // }

      if (response.status == 200) {
        // **FIX:** Show success message
        _showSuccessSnackBar("Welcome, you're successfully registered!");

        // Wait for a moment so the user can see the message
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      } else {
        // **FIX:** Show a specific error message for wrong PIN
        _showErrorSnackBar("You've entered the wrong pin");
      }
    } catch (e) {
      // **FIX:** Show a generic error for network or other issues
      _showErrorSnackBar("You've entered the wrong pin");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // void _showErrorSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.red),
  //   );
  // }
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

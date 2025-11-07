// lib/screens/login_page.dart

import 'package:expense_splitter/api/settings_api_service.dart';
import 'package:expense_splitter/model/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/auth_api_service.dart';
import 'registration_page.dart';
import 'verify_otp_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  PhoneNumber? _fullPhoneNumber;
  bool _isLoading = false;
  final AuthApiService _apiService = AuthApiService();
  final SettingsApiService _settingsApiService = SettingsApiService();
  AppSettings? _appSettings;

  @override
  void initState() {
    super.initState();
    // Fetch settings when the page loads
    _fetchAppSettings();
  }


   Future<void> _fetchAppSettings() async {
    try {
      final settings = await _settingsApiService.fetchSettings();
      if (mounted) {
        setState(() {
          _appSettings = settings;
        });
      }
    } catch (e) {
      // It's okay if this fails, the links just won't work.
      // You might want to log this error for debugging.
      print("Failed to fetch app settings for login page: $e");
    }
  }

  // --- NEW: Helper to launch URLs ---
  Future<void> _launchURL(String? urlString) async {
    if (urlString != null && await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString), mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackBar('Could not open the link.');
    }
  }

  Future<void> _loginUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.login(
        mobile: _fullPhoneNumber!.number,
        countryCode: _fullPhoneNumber!.countryCode,
      );

      if (response.status == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpLogin(
              userId: response.userId,
              phoneNumber: _fullPhoneNumber!.completeNumber,
            ),
          ),
        );
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to login. Please check your credentials.');
      _showErrorSnackBar('Please Register if You\'re new ');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: Colors.red,behavior:SnackBarBehavior.floating,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/authentication_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo_header.png', height: 220, width: 280),
                    const SizedBox(height: 0),
                    IntlPhoneField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Mobile Number',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        _fullPhoneNumber = phone;
                      },
                      validator: (phone) => (phone == null || phone.number.isEmpty) ? 'Please enter your mobile number' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1E57),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Send OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("If you're new, ", style: TextStyle(color: Colors.white)),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage())),
                          child: const Text('PLEASE REGISTER', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 230),


          _buildFooter(),

                  ],
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
  Widget _buildFooter() {
    // Show a placeholder while settings are loading
    if (_appSettings == null) {
      return const SizedBox(height: 20); // Or a small loader
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterLink('Contact', () => _launchURL(_appSettings?.contact)),
        _buildFooterDivider(),
        _buildFooterLink('Terms', () => _launchURL(_appSettings?.terms)),
        _buildFooterDivider(),
        _buildFooterLink('Policy', () => _launchURL(_appSettings?.privacy)),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          // decoration: TextDecoration.underline,
          decorationColor: Colors.white
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|', style: TextStyle(color: Colors.white70)),
    );
  }

}

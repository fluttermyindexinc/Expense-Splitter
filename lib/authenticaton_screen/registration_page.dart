import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../api/auth_api_service.dart';
import 'verify_otp_registration.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber? _fullPhoneNumber;
  bool _isLoading = false;
  final AuthApiService _apiService = AuthApiService();

  Future<void> _registerUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_fullPhoneNumber == null || _fullPhoneNumber!.number.isEmpty) {
      _showErrorSnackBar('Please provide a valid phone number.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.registerUser(
        name: _nameController.text,
        email: _emailController.text,
        mobile: _fullPhoneNumber!.number,
        countryCode: _fullPhoneNumber!.countryCode,
      );

      if (response.status == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpRegistration(
              userId: response.userId,
              phoneNumber: _fullPhoneNumber!.completeNumber,
            ),
          ),
        );
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: Colors.red),
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
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                     validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
                      // MODIFICATION: Enforces PascalCase/TitleCase formatting on text change.
                      onChanged: (value) {
                        String capitalizedValue = value.split(' ').map((word) {
                          if (word.isEmpty) return '';
                          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
                        }).join(' ');
                        _nameController.value = TextEditingValue(
                          text: capitalizedValue,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: capitalizedValue.length),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                        onPressed: _isLoading ? null : _registerUser,
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
                        const Text(
                          'Already registered? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'PLEASE LOGIN',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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

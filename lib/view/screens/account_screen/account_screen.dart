// lib/screens/account_screen.dart

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Method to show a dialog for choosing image source
  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to pick an image
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light grey background
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: const Color.fromARGB(234, 0, 41, 118),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color.fromARGB(234, 13, 78, 197),const Color.fromARGB(234, 0, 19, 53)])
          ),
        ),
        toolbarHeight: 80,
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.lightbulb, color: Colors.white),
            onPressed: () {
              // TODO: Implement settings action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            _buildProfilePictureSection(),
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 40), // Space before the copyright
            _buildCopyright(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            GestureDetector(
              onTap: _showImageSourceActionSheet,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Color.fromARGB(255, 0, 52, 141),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            label: 'Name',
            value: 'Kristien',
          ),
          const Divider(),
          _buildInfoTile(
            label: 'Email',
            value: 'kristien@example.com',
          ),
          const Divider(),
          _buildInfoTile(
            label: 'Mobile Number',
            value: '+1 234 567 890',
          ),
          const Divider(),
          _buildInfoTile(
            label: 'Update Password',
            value: '', // No value to display
            isAction: true,
            onTap: () {
              // TODO: Navigate to update password page
            },
          ),
          const Divider(),
          _buildInfoTile(
            label: 'Log out all devices',
            value: '', // No value to display
            isAction: true,
            onTap: () {
              // TODO: Implement logout functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    bool isAction = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: isAction
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildCopyright() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Padding at the very bottom of the page
        child: const Text(
          'Copyright © Expense Splitter 2025. All Rights Reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:expense_splitter/api/profile_api_service.dart';
import 'package:expense_splitter/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:expense_splitter/authenticaton_screen/login_page.dart';
import 'package:expense_splitter/model/auth_models.dart';

class AccountScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;
  const AccountScreen({super.key, required this.onProfileUpdated});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // All your state variables and methods (_isSaving, _name, _profileApiService, etc.)
  // and the methods like _handleRefresh(), _loadUserDataFromPrefs(), _updateProfile()
  // from the previous answer remain exactly the same.
  // The only change is in the `build` method.

  // --- OMITTED FOR BREVITY: All methods from initState to _pickImage are unchanged ---
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final ProfileApiService _profileApiService = ProfileApiService();
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _mobile = 'Loading...';
  String _username = 'Loading...';
  String _playStoreUrl = '';
  String _fullDpUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserDataFromPrefs();
    _handleRefresh();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    try {
      final User user = await _profileApiService.getProfile();
      await SessionManager.saveUserData(user);
      await _loadUserDataFromPrefs();
      widget.onProfileUpdated();
      if (mounted) {
        _showFloatingSnackBar('Profile synced successfully!', isError: false);
      }
    } catch (e) {
      if (mounted) {
        _showFloatingSnackBar('Failed to sync profile: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _loadUserDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String dpBaseUrl = dotenv.env['DP_IMAGE_URL'] ?? '';
    final String? dpFileName = prefs.getString('dp');
    if (mounted) {
      setState(() {
        _name = prefs.getString('name') ?? 'N/A';
        _email = prefs.getString('email') ?? 'N/A';
        final countryCode = prefs.getString('country_code') ?? '';
        final mobileNumber = prefs.getString('mobile') ?? '';
        _mobile = '+$countryCode $mobileNumber';
        _username = prefs.getString('username') ?? 'N/A';
        _playStoreUrl = prefs.getString('play_store') ??
            'https://play.google.com/store/apps/details?id=com.expensesplitter.app';
        _fullDpUrl =
            (dpFileName != null && dpFileName.isNotEmpty) ? '$dpBaseUrl/$dpFileName' : '';
      });
    }
  }

    void _showFloatingSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor:
            isError ? Colors.redAccent : Colors.black.withOpacity(0.7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        elevation: 6.0,
      ),
    );
  }

  Future<void> _updateProfile({String? newName}) async {
    if (newName == null && _profileImage == null) {
      _showFloatingSnackBar('No changes to save.', isError: true);
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) throw Exception('User not logged in.');
      final response = await _profileApiService.updateProfile(
        userId: userId,
        name: newName,
        imageFile: _profileImage,
      );
      if (mounted) {
        if (response.status == 200) {
          if (response.user != null) {
            await SessionManager.saveUserData(response.user!);
          }
          _showFloatingSnackBar(response.message);
          setState(() {
            _profileImage = null;
          });
          await _loadUserDataFromPrefs();
          widget.onProfileUpdated();
        } else {
          throw Exception(response.message);
        }
      }
    } catch (e) {
      _showFloatingSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showEditNameDialog() {
    _nameController.text = _name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Name'),
          content: TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter your new name"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFFFF013A))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  const Text('Save', style: TextStyle(color: Color(0xFF1A1E57))),
              onPressed: () {
                Navigator.of(context).pop();
                if (_nameController.text != _name) {
                  _updateProfile(newName: _nameController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _copyUsername() {
    Clipboard.setData(ClipboardData(text: _username));
    _showFloatingSnackBar('Username copied to clipboard');
  }

  void _shareUsername() {
    final shareText =
        'Check out Expense Splitter and add me with my username: $_username\n\nDownload the app here: $_playStoreUrl';
    Share.share(shareText);
  }

  Future<void> _performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(28.0),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xFF1A1E57),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1A1E57),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                color: Color(0xFFFF013A), fontSize: 15),
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text(
                            'OK',
                            style: TextStyle(
                                color: Color(0xFF1A1E57),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _performLogout();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _updateProfile();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/your_appbar_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        toolbarHeight: 100,
        title: const Text('Account',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 22)),
        foregroundColor: Colors.white,
        elevation: 10,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF1A1E57),
        
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensures the pull-to-refresh gesture is always available
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 18),
                _buildProfileSection(),
                const SizedBox(height: 14),
                _buildInfoSection(),
                const SizedBox(height: 24),
                _buildLogoutButton(),
                const SizedBox(height: 40),
                _buildCopyright(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
          CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (_fullDpUrl.isNotEmpty
                      ? NetworkImage(_fullDpUrl)
                      : null) as ImageProvider?,
              child: _profileImage == null && _fullDpUrl.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            GestureDetector(
              onTap: _isSaving ? null : _showImageSourceActionSheet,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(255, 0, 52, 141),
                child: _isSaving 
                  ? const Padding(padding: EdgeInsets.all(4.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.camera_alt, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),    
          
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                  'Username :',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:Colors.black54, fontStyle: FontStyle.italic,),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Text(
                  _username,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:Colors.black54),
                ),
              ),
              SizedBox(width: 16,),
              IconButton(
                icon: const Icon(Icons.copy, size: 20, color: Colors.black54),
                onPressed: _copyUsername,
              ),
              IconButton(
                icon: const Icon(Icons.share, size: 20, color: Colors.black54),
                onPressed: _shareUsername,
              ),
            ],
          ),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
         ListTile(
            title: const Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _name,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                  onPressed: _showEditNameDialog,
                ),
              ],
            ),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          _buildInfoTile(label: 'Email', value: _email),
          const Divider(),
          _buildInfoTile(label: 'Mobile', value: _mobile),
        ],
      ),
    );
  }

  // Widget _buildLogoutButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton.icon(
  //       // icon: const Icon(Icons.logout, color: Colors.white),
  //       label: const Text(
  //         'Logout',
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       // --- THE FIX: Call the dialog instead of logging out directly ---
  //       onPressed: _showLogoutDialog,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xFFFF013A),
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // In your _AccountScreenState class

Widget _buildLogoutButton() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      // The background image for the button
      image: const DecorationImage(
        image: AssetImage('assets/images/your_button_background.png'), // <-- Your image path here
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ElevatedButton.icon(
      // icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onPressed: _showLogoutDialog,
      style: ElevatedButton.styleFrom(
        // Make the button's own background transparent to see the image
        backgroundColor: const Color(0xFFFF013A).withOpacity(0.0), // Red with 70% opacity
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}


  Widget _buildInfoTile({required String label, required String value}) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildCopyright() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Text(
        'Copyright © Expense Splitter 2025. All Rights Reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}

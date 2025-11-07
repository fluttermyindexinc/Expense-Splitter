import 'package:expense_splitter/authenticaton_screen/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expense_splitter/api/settings_api_service.dart';
import 'package:expense_splitter/model/settings_model.dart';
class AppDrawer extends StatefulWidget {
  final VoidCallback onNavigateToAllGroups;
  final VoidCallback onNavigateToProfile;
final String userName;
  final String userUsername;
  final String? fullDpUrl;


  const AppDrawer({super.key,required this.onNavigateToAllGroups,
    required this.onNavigateToProfile,required this.userName,
    required this.userUsername,
    this.fullDpUrl,});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}
class _AppDrawerState extends State<AppDrawer> {
  final SettingsApiService _settingsApiService = SettingsApiService();
  AppSettings? _appSettings;

  // String _userName = 'User';
  // String _userUsername = '...';
  // String? _fullDpUrl;  


  @override
  void initState() {
    super.initState();
    _fetchAppSettings();
    // _loadUserData();
  }

  // Future<void> _loadUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String dpBaseUrl = dotenv.env['DP_IMAGE_URL'] ?? '';

  //   // 2. Get the user-specific filename from SharedPreferences
  //   final String? dpFileName = prefs.getString('dp');
  //   setState(() {
  //     _userName = prefs.getString('name') ?? 'User';
  //     _userUsername = prefs.getString('username') ?? '...';
      
  //     // 3. Construct the full URL if the filename exists
  //     if (dpFileName != null && dpFileName.isNotEmpty) {
  //       _fullDpUrl = '$dpBaseUrl/$dpFileName';
  //     }
  //   });
  // }

  // Fetch settings from the API
  Future<void> _fetchAppSettings() async {
    try {
      final settings = await _settingsApiService.fetchSettings();
      print(settings.contact);
      setState(() {
        _appSettings = settings;
      });
    } catch (e) {
      print("Failed to fetch app settings: $e");
      // Handle error, maybe show a snackbar
    }
  }

  // Helper function to launch a URL
  Future<void> _launchURL(String? urlString) async {
    if (urlString != null && await canLaunchUrl(Uri.parse(urlString))) {
      print(urlString);
      await launchUrl(Uri.parse(urlString), mode: LaunchMode.externalApplication);
    } else {
      // Handle error, maybe show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link')),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  // void _showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         // backgroundColor: Colors.white,
  //                   backgroundColor: Colors.white.withOpacity(0.6), // Shadow color

  //         title: const Text('Logout'),
  //         content: const Text('Are you sure you want to logout?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel' ,style: TextStyle(color: Color(0xFFFF013A),),),
  //             onPressed: () => Navigator.of(dialogContext).pop(),
  //           ),
  //           TextButton(
  //             child: const Text('OK',style: TextStyle(color:Color(0xFF1A1E57) ),),
  //             onPressed: () {
  //               Navigator.of(dialogContext).pop();
  //               _logout(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: Stack(
            children: <Widget>[ 
              Image.asset(
                'assets/images/change-modified-alert-bg.jpg', 
                 fit: BoxFit.cover,
                height: 170, 
                width: 300,
                // color: Colors.black.withOpacity(0.9),   
              ),  
              Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                         Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF1A1E57)
                          ),
                        ),
                         SizedBox(height: 16),
                         Text(
                          'Are you sure you want to logout?',
                          textAlign: TextAlign.center,
                           style: TextStyle(
                            color: Color(0xFF1A1E57)
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFFFF013A)),
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                        TextButton(
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Color(0xFF1A1E57)),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                _logout(context);

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        elevation: 24,
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/change-modified.jpg'),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
              // Colors.black.withOpacity(0.2),
              // BlendMode.darken,
            // ),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // _buildDrawerHeader(),
            _buildDrawerHeader(
              userName: widget.userName,
              userUsername: widget.userUsername,
              fullDpUrl: widget.fullDpUrl,
            ),
            _buildBalanceSection(),
            const SizedBox(height: 10),
             _buildDrawerItem(
              icon: CupertinoIcons.group, 
              text: 'All Groups', 
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer first
                widget.onNavigateToAllGroups(); // Then call the callback
              }
            ),
            _buildDrawerItem(icon: CupertinoIcons.book, text: 'Blogs', onTap: () => _launchURL(_appSettings?.blogs)),
            _buildDrawerItem(icon: CupertinoIcons.info, text: 'About Us', onTap: () => _launchURL(_appSettings?.about)),
            _buildDrawerItem(icon: CupertinoIcons.mail, text: 'Contact Us', onTap: () => _launchURL(_appSettings?.contact)),
            _buildDrawerItem(icon: CupertinoIcons.reply, text: 'Check for Updates', onTap: () => _launchURL(_appSettings?.playStore)),
            _buildDrawerItem(icon: CupertinoIcons.doc_text, text: 'Terms of Use', onTap: () => _launchURL(_appSettings?.terms)),
            _buildDrawerItem(icon: CupertinoIcons.shield, text: 'Privacy Policy', onTap: () => _launchURL(_appSettings?.privacy)),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            _buildDrawerItem(
              icon: CupertinoIcons.profile_circled, 
              text: 'Profile', 
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                widget.onNavigateToProfile(); // Call the callback
              }
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.square_arrow_left, color:Color(0xFFFF013A)),
              title: const Text('Logout', style: TextStyle(color: Colors.black)),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildDrawerHeader({
    required String userName,
    required String userUsername,
    String? fullDpUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: (fullDpUrl != null && fullDpUrl.isNotEmpty)
                ? NetworkImage(fullDpUrl)
                : const AssetImage('assets/images/profile_pic.jpeg') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName, // Use the passed-in userName
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userUsername, // Use the passed-in userUsername
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBalanceSection() {
   
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          SizedBox(height: 8),    
          Row(
            children: [
              Text(
                '₹ -247',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '.67',
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildSectionTitle(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
  //     child: Text(
  //       title.toUpperCase(),
  //       style: const TextStyle(
  //         color: Colors.white54,
  //         fontWeight: FontWeight.bold,
  //         letterSpacing: 1.2,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDrawerItem({required IconData icon, required String text,required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(text, style: const TextStyle(color: Colors.black, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black38, size: 14),
      onTap: onTap,
    );
  }

//   Widget _buildThemeToggle() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Row(
//             children: [
//               Icon(CupertinoIcons.moon, color: Colors.white70),
//               SizedBox(width: 16),
//               Text('Dark Mode', style: TextStyle(color: Colors.white, fontSize: 16)),
//             ],
//           ),
//           Switch(
//             value: true, // Example value
//             onChanged: (value) {
//               // TODO: Handle theme change
//             },
//             activeTrackColor: Colors.green.shade700,
//             activeColor: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
}







import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // FIX: Replace the color property with a decoration to use an image.
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/change-modified.jpg'), // Your image path here
            fit: BoxFit.cover,
            // Add a color filter to darken the image for better text contrast.
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            _buildBalanceSection(),
            const SizedBox(height: 10),
            // _buildSectionTitle('Tools'),
            _buildDrawerItem(icon: CupertinoIcons.group, text: 'All Groups'),
            _buildDrawerItem(icon: CupertinoIcons.book, text: 'Blogs'),
            _buildDrawerItem(icon: CupertinoIcons.info, text: 'About Us'),
            _buildDrawerItem(icon: CupertinoIcons.mail, text: 'Contact Us'),
            _buildDrawerItem(icon: CupertinoIcons.reply, text: 'Check for Updates'),
            _buildDrawerItem(icon: CupertinoIcons.doc_text, text: 'Terms of Use'),
            _buildDrawerItem(icon: CupertinoIcons.shield, text: 'Privacy Policy'),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            // _buildSectionTitle('Tools'), // Duplicated as in image
            _buildDrawerItem(icon: CupertinoIcons.profile_circled, text: 'Profile'),
            _buildDrawerItem(icon: CupertinoIcons.square_arrow_left, text: 'Logout'),
            // const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            // _buildSectionTitle('Theme'),
            // _buildThemeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/profile_pic.jpeg'), // Your profile image
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kristien',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'EXPS0047',
                style: TextStyle(
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
    // To make this stand out, we can use a semi-transparent background.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10.withOpacity(0.1), // Semi-transparent white
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

  Widget _buildDrawerItem({required IconData icon, required String text}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(text, style: const TextStyle(color: Colors.black, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black38, size: 14),
      onTap: () {
        // TODO: Handle navigation
      },
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

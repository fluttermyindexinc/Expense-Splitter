// import 'dart:async';
// import 'package:expense_splitter/view/screens/all_group_screen/all_group_screen.dart';
// import 'package:expense_splitter/view/screens/my_expenses/my_expenses.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:ui'; // Required for ImageFilter.blur
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// // Your existing screen imports
// import 'package:expense_splitter/view/screens/account_screen/account_screen.dart';
// import 'package:expense_splitter/view/screens/home/home.dart';
// import 'package:expense_splitter/view/screens/drawer/app_drawer.dart';

// // --- 1. Import your ad-related files ---
// import 'package:expense_splitter/api/ad_api_service.dart';
// import 'package:expense_splitter/model/ad_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late final List<Widget> _pages;

//   // --- 2. Instantiate your AdApiService ---
//   final AdApiService _adApiService = AdApiService();

//     String _userName = 'User';
//   String _userUsername = '...';
//   String? _fullDpUrl;

//   @override
//   void initState() {
//     super.initState();

//      _loadUserData();

//     _pages = <Widget>[
//       HomeScreen(
//         scaffoldKey: _scaffoldKey,
//         // When this is called, it will trigger the navigation
//         onNavigateToMyExpenses: () => _onItemTapped(2), 
//          userName: _userName,
//         fullDpUrl: _fullDpUrl,
//       ),
//       AllGroupsScreen(),
//       MyExpensesScreen(),
//       AccountScreen( onProfileUpdated: _loadUserData,),
//     ];

//     // --- 3. Add the call to show the ad popup ---
//     // This ensures the dialog is shown only after the screen is fully built.
//     WidgetsBinding.instance.addPostFrameCallback((_) => _showAdPopup());
//   }

//   // --- 4. Function to fetch and show the ad popup ---
//   Future<void> _showAdPopup() async {
//     try {
//       final Ad ad = await _adApiService.fetchAd();
//       if (!mounted) return;

//       // Show the ad in a dismissible dialog.
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             insetPadding: const EdgeInsets.all(20.0),
//             backgroundColor: Colors.transparent, // Make dialog background transparent
//             child: Stack(
//               children: [
//                 // The ad image
//                 GestureDetector(
//                   onTap: () => Navigator.of(context).pop(), // Tapping image closes it
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       image: DecorationImage(
//                         image: NetworkImage(ad.imageUrl),
//                         fit: BoxFit.cover,
//                         onError: (exception, stackTrace) {
//                           print("Error loading ad image: $exception");
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 // A clearly visible close button
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.black.withOpacity(0.5),
//                     child: IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       // If fetching or displaying the ad fails, just log the error and continue.
//       print("Failed to show ad popup: $e");
//     }
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String dpBaseUrl = dotenv.env['DP_IMAGE_URL'] ?? '';
//     final String? dpFileName = prefs.getString('dp');
    
//     // Use a local key that combines the data to ensure it's unique
//     final newName = prefs.getString('name') ?? 'User';
//     final newDpUrl = dpFileName != null && dpFileName.isNotEmpty ? '$dpBaseUrl/$dpFileName' : null;

//     setState(() {
//       _userName = newName;
//       _userUsername = prefs.getString('username') ?? '...';
//       _fullDpUrl = newDpUrl;
      
//       // --- THE FIX: Rebuild the pages list with a unique ValueKey for HomeScreen ---
//       _pages = [
//         HomeScreen(
//           // By using a key that changes when the data changes, we force Flutter to
//           // rebuild the HomeScreen widget from scratch with the new props.
//           key: ValueKey('$_userName$_fullDpUrl'), 
//           scaffoldKey: _scaffoldKey,
//           onNavigateToMyExpenses: () => _onItemTapped(2),
//           userName: _userName,
//         // userUsername: _userUsername,
//         fullDpUrl: _fullDpUrl,
//         ),
//         AllGroupsScreen(),
//         MyExpensesScreen(),
//         AccountScreen(onProfileUpdated: _loadUserData),
//       ];
//     });
//   }


//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: AppDrawer(
//         onNavigateToAllGroups: () => _onItemTapped(1), // Index 1 is AllGroupsScreen
//         onNavigateToProfile: () => _onItemTapped(3),   // Index 3 is AccountScreen
//         userName: _userName,
//         userUsername: _userUsername,
//         fullDpUrl: _fullDpUrl,
//       ),
//       extendBody: true,
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: _buildCustomBottomNav(),
//     );
//   }

//   Widget _buildCustomBottomNav() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(255, 66, 65, 65).withOpacity(0.45),
//             blurRadius: 10,
//             offset: const Offset(0, 20),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: Colors.white.withOpacity(0.2)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(icon: CupertinoIcons.home, label: 'Home', index: 0),
//                 _buildNavItem(icon: CupertinoIcons.group_solid, label: 'Group', index: 1),
//                 _buildNavItem(icon: FontAwesomeIcons.wallet, label: 'My Expenses', index: 2),
//                 _buildNavItem(icon: CupertinoIcons.person_solid, label: 'Account', index: 3),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required IconData icon,
//     required String label,
//     required int index,
//   }) {
//     bool isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 400),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color.fromARGB(234, 0, 41, 118)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.black.withOpacity(0.7),
//               size: 24,
//             ),
//             if (isSelected) ...[
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:expense_splitter/view/screens/all_group_screen/all_group_screen.dart';
import 'package:expense_splitter/view/screens/my_expenses/my_expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:ui'; // Required for ImageFilter.blur
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Your existing screen imports
import 'package:expense_splitter/view/screens/account_screen/account_screen.dart';
import 'package:expense_splitter/view/screens/home/home.dart';
import 'package:expense_splitter/view/screens/drawer/app_drawer.dart';

// --- 1. Import your ad-related files ---
import 'package:expense_splitter/api/ad_api_service.dart';
import 'package:expense_splitter/model/ad_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Widget> _pages; // Changed to non-final

  // --- 2. Instantiate your AdApiService ---
  final AdApiService _adApiService = AdApiService();

  String _userName = 'User';
  String _userUsername = '...';
  String? _fullDpUrl;

  @override
  void initState() {
    super.initState();
    _pages = []; // Initialize as empty to show a loader
    _loadUserData(); // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAdPopup());
  }

  // --- 4. Function to fetch and show the ad popup ---
  Future<void> _showAdPopup() async {
    try {
      final Ad ad = await _adApiService.fetchAd();
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(20.0),
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(ad.imageUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          print("Error loading ad image: $exception");
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print("Failed to show ad popup: $e");
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String dpBaseUrl = dotenv.env['DP_IMAGE_URL'] ?? '';
    final String? dpFileName = prefs.getString('dp');
    
    final newName = prefs.getString('name') ?? 'User';
    final newDpUrl = dpFileName != null && dpFileName.isNotEmpty 
        ? '$dpBaseUrl/$dpFileName' 
        : null;

    setState(() {
      _userName = newName;
      _userUsername = prefs.getString('username') ?? '...';
      _fullDpUrl = newDpUrl;
      
      // --- THE FIX: Rebuild the pages list with a unique ValueKey for HomeScreen ---
      final uniqueKey = ValueKey('$_userName$_fullDpUrl${DateTime.now().millisecondsSinceEpoch}');

      _pages = [
        HomeScreen(
          key: uniqueKey,
          scaffoldKey: _scaffoldKey,
          onNavigateToMyExpenses: () => _onItemTapped(2),
          userName: _userName,
          fullDpUrl: _fullDpUrl,
        ),
        AllGroupsScreen(),
        MyExpensesScreen(),
        AccountScreen(onProfileUpdated: _loadUserData),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen until the pages list is populated
    if (_pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        onNavigateToAllGroups: () => _onItemTapped(1),
        onNavigateToProfile: () => _onItemTapped(3),
        userName: _userName,
        userUsername: _userUsername,
        fullDpUrl: _fullDpUrl,
      ),
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 66, 65, 65).withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: CupertinoIcons.home, label: 'Home', index: 0),
                _buildNavItem(icon: CupertinoIcons.group_solid, label: 'Group', index: 1),
                _buildNavItem(icon: FontAwesomeIcons.wallet, label: 'My Expenses', index: 2),
                _buildNavItem(icon: CupertinoIcons.person_solid, label: 'Account', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(234, 0, 41, 118)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.7),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

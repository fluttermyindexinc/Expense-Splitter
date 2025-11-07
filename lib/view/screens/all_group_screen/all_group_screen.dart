// import 'package:expense_splitter/view/screens/home/created_group_page.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/groups_api_service.dart';
// import 'package:expense_splitter/model/group_list_model.dart';
// // import 'package:expense_splitter/view/screens/all_groups/created_group_page.dart';

// class AllGroupsScreen extends StatefulWidget {
//   const AllGroupsScreen({super.key});

//   @override
//   State<AllGroupsScreen> createState() => _AllGroupsScreenState();
// }

// class _AllGroupsScreenState extends State<AllGroupsScreen> {
//   final GroupsApiService _apiService = GroupsApiService();
//   // --- THE FIX: Change how the Future is declared ---
//   Future<GroupsResponse>? _groupsFuture;
//   int _currentStatus = 1;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the future directly here
//     _groupsFuture = _apiService.fetchGroups(status: _currentStatus);
//   }

//   // This method now just re-assigns the future
//   void _loadGroups() {
//     setState(() {
//       _groupsFuture = _apiService.fetchGroups(status: _currentStatus);
//     });
//   }

//   void _toggleGroupStatus() {
//     setState(() {
//       _currentStatus = _currentStatus == 1 ? 0 : 1;
//       _loadGroups(); // Call the method to fetch the new list
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_currentStatus == 1 ? "Active Groups" : "Closed Groups"),
//         foregroundColor: Colors.white,
//         toolbarHeight: 80,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//         // Replace with the path to your background image asset.
//         image: AssetImage('assets/images/your_appbar_background.jpg'),
//         // This ensures the image covers the entire AppBar.
//         fit: BoxFit.cover,
//       ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(_currentStatus == 1 ? Icons.inventory_2_outlined : Icons.lock_open_outlined),
//             tooltip: _currentStatus == 1 ? 'Show Closed Groups' : 'Show Active Groups',
//             onPressed: _toggleGroupStatus,
//           ),
//         ],
//       ),
//       body: FutureBuilder<GroupsResponse>(
//         future: _groupsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData || snapshot.data!.groups.isEmpty) {
//             return Center(
//               child: Text(
//                 _currentStatus == 1 ? "No active groups found." : "No closed groups found.",
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }

//           final groups = snapshot.data!.groups;
//           return ListView.builder(
//             itemCount: groups.length,
//             itemBuilder: (context, index) {
//               return GroupCard(group: groups[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// // --- Group Card Widget ---
// class GroupCard extends StatelessWidget {
//   final Group group;

//   const GroupCard({super.key, required this.group});

//   // Map to hold the asset paths for each group type
//   static final Map<String, String> _typeToIcon = {
//     'Trip': 'assets/images/trip.png',
//     'Room': 'assets/images/room.png',
//     'Office': 'assets/images/office.png',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final iconPath = _typeToIcon[group.type] ?? 'assets/images/default_group_icon.png';
    
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreatedGroupPage(
//                 groupId: group.id,
//                 groupName: group.name,
//                 groupType: group.type,
//                 groupImage: iconPath,
//                 createdDate: DateFormat('MMM dd, yyyy').format(DateTime.parse(group.createdAt)),
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Image.asset(iconPath, width: 40, height: 40),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       group.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       group.type,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/groups_api_service.dart';
// import 'package:expense_splitter/model/group_list_model.dart';
// import 'package:expense_splitter/view/screens/home/created_group_page.dart';

// class AllGroupsScreen extends StatefulWidget {
//   const AllGroupsScreen({super.key});

//   @override
//   State<AllGroupsScreen> createState() => _AllGroupsScreenState();
// }

// // --- Add SingleTickerProviderStateMixin for the TabController ---
// class _AllGroupsScreenState extends State<AllGroupsScreen> with SingleTickerProviderStateMixin {
//   final GroupsApiService _apiService = GroupsApiService();
//   late TabController _tabController;

//   // --- Create separate Future variables for each tab ---
//   late Future<GroupsResponse> _activeGroupsFuture;
//   late Future<GroupsResponse> _closedGroupsFuture;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the TabController
//     _tabController = TabController(length: 2, vsync: this);
    
//     // Load the data for both tabs immediately
//     _activeGroupsFuture = _apiService.fetchGroups(status: 1);
//     _closedGroupsFuture = _apiService.fetchGroups(status: 0);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Groups', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20)),
//         foregroundColor: Colors.white,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/your_appbar_background.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // --- Add the TabBar to the bottom of the AppBar ---
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           indicatorColor: Colors.white,
//           tabs: const [
//             Tab(text: 'Active'),
//             Tab(text: 'Closed'),
//           ],
//         ),
//       ),
//       // --- Use a TabBarView to display the content for each tab ---
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Content for the "Active" tab
//           GroupList(groupsFuture: _activeGroupsFuture, status: "active"),
//           // Content for the "Closed" tab
//           GroupList(groupsFuture: _closedGroupsFuture, status: "closed"),
//         ],
//       ),
//     );
//   }
// }

// // --- Helper Widget to Display the List of Groups ---
// class GroupList extends StatelessWidget {
//   final Future<GroupsResponse> groupsFuture;
//   final String status;

//   const GroupList({super.key, required this.groupsFuture, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<GroupsResponse>(
//       future: groupsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }
//         if (!snapshot.hasData || snapshot.data!.groups.isEmpty) {
//           return Center(
//             child: Text(
//               "No $status groups found.",
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           );
//         }

//         final groups = snapshot.data!.groups;
//         return ListView.builder(
//           itemCount: groups.length,
//           itemBuilder: (context, index) {
//             return GroupCard(group: groups[index]);
//           },
//         );
//       },
//     );
//   }
// }

// // --- No Changes needed for the GroupCard Widget ---
// class GroupCard extends StatelessWidget {
//   final Group group;

//   const GroupCard({super.key, required this.group});

//   static final Map<String, String> _typeToIcon = {
//     'Trip': 'assets/images/trip.png',
//     'Room': 'assets/images/room.png',
//     'Office': 'assets/images/office.png',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final iconPath = _typeToIcon[group.type] ?? 'assets/images/default_group_icon.png';
    
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreatedGroupPage(
//                 groupId: group.id,
//                 groupName: group.name,
//                 groupType: group.type,
//                 groupImage: iconPath,
//                 createdDate: DateFormat('MMM dd, yyyy').format(DateTime.parse(group.createdAt)),
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Image.asset(iconPath, width: 40, height: 40),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       group.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       group.type,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/groups_api_service.dart';
// import 'package:expense_splitter/model/group_list_model.dart';
// import 'package:expense_splitter/view/screens/home/created_group_page.dart';

// class AllGroupsScreen extends StatefulWidget {
//   const AllGroupsScreen({super.key});

//   @override
//   State<AllGroupsScreen> createState() => _AllGroupsScreenState();
// }

// class _AllGroupsScreenState extends State<AllGroupsScreen> with SingleTickerProviderStateMixin {
//   final GroupsApiService _apiService = GroupsApiService();
//   late TabController _tabController;
//   late Future<GroupsResponse> _activeGroupsFuture;
//   late Future<GroupsResponse> _closedGroupsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _activeGroupsFuture = _apiService.fetchGroups(status: 1);
//     _closedGroupsFuture = _apiService.fetchGroups(status: 0);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // --- THE FIX: Use a Stack for the background image ---
//     return Stack(
//       children: [
//         // Layer 1: The background image
//         Positioned.fill(
//           child: Image.asset(
//             'assets/images/change-modified.jpg', // <-- Replace with your main background image
//             fit: BoxFit.cover,
//           ),
//         ),
//         // Layer 2: The UI content
//         Scaffold(
//           backgroundColor: Colors.transparent, // Make scaffold transparent
//           appBar: AppBar(
//             flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//         // Replace with the path to your background image asset.
//         image: AssetImage('assets/images/your_appbar_background.jpg'),
//         // This ensures the image covers the entire AppBar.
//         fit: BoxFit.cover,
//       ),
//           ),
//         ),
//         toolbarHeight: 80,
//             title: const Text('All Groups', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20)),
//             backgroundColor: Colors.transparent, // Make appbar transparent
//             elevation: 0, // Remove shadow
//             foregroundColor: Colors.white,
//             bottom: TabBar(
//               controller: _tabController,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white70,
//               indicatorColor: Colors.white,
//               indicatorWeight: 3,
//               tabs: const [
//                 Tab(text: 'Active'),
//                 Tab(text: 'Closed'),
//               ],
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.only(bottom:  60.0),
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 GroupList(groupsFuture: _activeGroupsFuture, status: "active"),
//                 GroupList(groupsFuture: _closedGroupsFuture, status: "closed"),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // --- No changes to the helper widgets below ---

// class GroupList extends StatelessWidget {
//   final Future<GroupsResponse> groupsFuture;
//   final String status;

//   const GroupList({super.key, required this.groupsFuture, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<GroupsResponse>(
//       future: groupsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator(color: Colors.white));
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
//         }
//         if (!snapshot.hasData || snapshot.data!.groups.isEmpty) {
//           return Center(
//             child: Text(
//               "No $status groups found.",
//               style: const TextStyle(fontSize: 16, color: Colors.black45),
//             ),
//           );
//         }

//         final groups = snapshot.data!.groups;
//         return ListView.builder(
//           padding: const EdgeInsets.only(top: 8),
//           itemCount: groups.length,
//           itemBuilder: (context, index) {
//             return GroupCard(group: groups[index]);
//           },
//         );
//       },
//     );
//   }
// }

// class GroupCard extends StatelessWidget {
//   final Group group;

//   const GroupCard({super.key, required this.group});

//   static final Map<String, String> _typeToIcon = {
//     'Trip': 'assets/images/trip.png',
//     'Room': 'assets/images/room.png',
//     'Office': 'assets/images/office.png',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final iconPath = _typeToIcon[group.type] ?? 'assets/images/default_group_icon.png';
    
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreatedGroupPage(
//                 groupId: group.id,
//                 groupName: group.name,
//                 groupType: group.type,
//                 groupImage: iconPath,
//                 createdDate: DateFormat('MMM dd, yyyy').format(DateTime.parse(group.createdAt)),
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Image.asset(iconPath, width: 40, height: 40),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       group.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       group.type,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/groups_api_service.dart';
// import 'package:expense_splitter/model/group_list_model.dart';
// import 'package:expense_splitter/view/screens/home/created_group_page.dart';

// class AllGroupsScreen extends StatefulWidget {
//   const AllGroupsScreen({super.key});

//   @override
//   State<AllGroupsScreen> createState() => _AllGroupsScreenState();
// }

// class _AllGroupsScreenState extends State<AllGroupsScreen> with SingleTickerProviderStateMixin {
//   final GroupsApiService _apiService = GroupsApiService();
//   late TabController _tabController;
//   late Future<GroupsResponse> _activeGroupsFuture;
//   late Future<GroupsResponse> _closedGroupsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     // Initial data fetch
//     _refreshAllGroups(); 
//   }

//   // This method re-fetches the data for both tabs.
//   Future<void> _refreshAllGroups() async {
//     setState(() {
//       _activeGroupsFuture = _apiService.fetchGroups(status: 1);
//       _closedGroupsFuture = _apiService.fetchGroups(status: 0);
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset('assets/images/change-modified.jpg', fit: BoxFit.cover),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             flexibleSpace: Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/your_appbar_background.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             toolbarHeight: 80,
//             title: const Text('All Groups', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20)),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             foregroundColor: Colors.white,
//             bottom: TabBar(
//               controller: _tabController,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white70,
//               indicatorColor: Colors.white,
//               indicatorWeight: 3,
//               tabs: const [
//                 Tab(text: 'Active'),
//                 Tab(text: 'Closed'),
//               ],
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.only(bottom: 60.0),
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // Pass the refresh function to the GroupList for the "Active" tab
//                 GroupList(
//                   groupsFuture: _activeGroupsFuture,
//                   status: "active",
//                   onRefresh: _refreshAllGroups, // <-- Pass the refresh handler
//                   onDataChanged: _refreshAllGroups,
//                 ),
//                 // Pass the refresh function to the GroupList for the "Closed" tab
//                 GroupList(
//                   groupsFuture: _closedGroupsFuture,
//                   status: "closed",
//                   onRefresh: _refreshAllGroups, // <-- Pass the refresh handler
//                   onDataChanged: _refreshAllGroups,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // --- Helper Widget to Display the List of Groups ---
// class GroupList extends StatelessWidget {
//   final Future<GroupsResponse> groupsFuture;
//   final String status;
//   final Future<void> Function() onRefresh; // Accept the refresh handler
//   final VoidCallback onDataChanged;

//   const GroupList({
//     super.key,
//     required this.groupsFuture,
//     required this.status,
//     required this.onRefresh, // Add to constructor
//     required this.onDataChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // --- THE FIX: Wrap the FutureBuilder in a RefreshIndicator ---
//     return RefreshIndicator(
//       onRefresh: onRefresh, // Use the passed-in refresh handler
//       color: const Color(0xFF1A1E57),
//       child: FutureBuilder<GroupsResponse>(
//         future: groupsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: Colors.white));
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
//           }
//           if (!snapshot.hasData || snapshot.data!.groups.isEmpty) {
//             // This part is also scrollable now, allowing refresh on an empty list
//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                     child: Center(
//                       child: Text(
//                         "No $status groups found.",
//                         style: const TextStyle(fontSize: 16, color: Colors.black45),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           final groups = snapshot.data!.groups;
//           // The ListView.builder is already scrollable, so it works perfectly.
//           return ListView.builder(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.only(top: 8),
//             itemCount: groups.length,
//             itemBuilder: (context, index) {
//               return GroupCard(group: groups[index], onDataChanged: onDataChanged);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class GroupCard extends StatelessWidget {
//   final Group group;
//   // --- Accept the callback function ---
//   final VoidCallback onDataChanged;

//   const GroupCard({
//     super.key,
//     required this.group,
//     required this.onDataChanged,
//   });

//   static final Map<String, String> _typeToIcon = {
//     'Trip': 'assets/images/trip.png',
//     'Room': 'assets/images/room.png',
//     'Office': 'assets/images/office.png',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final iconPath = _typeToIcon[group.type] ?? 'assets/images/default_group_icon.png';
    
//     return Card(
//       // --- FIX: Conditional color for the card ---
//       color: group.status == 0 ?  Colors.white : Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         // --- FIX: Make onTap async to await the result ---
//         onTap: () async {
//           // Await the result from the CreatedGroupPage
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreatedGroupPage(
//                 groupId: group.id,
//                 groupName: group.name,
//                 groupType: group.type,
//                 groupImage: iconPath,
//                 createdDate: DateFormat('MMM dd, yyyy').format(DateTime.parse(group.createdAt)),
//               ),
//             ),
//           );

//           // If the page was popped with a 'true' value, it means data changed.
//           if (result == true) {
//             onDataChanged(); // Trigger the refresh
//           }
//         },
//         child: Padding(
//           // ... The rest of your card content remains the same
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Image.asset(iconPath, width: 40, height: 40),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       group.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       group.type,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_splitter/api/groups_api_service.dart';
import 'package:expense_splitter/model/group_list_model.dart';
import 'package:expense_splitter/view/screens/home/created_group_page.dart';

class AllGroupsScreen extends StatefulWidget {
  const AllGroupsScreen({super.key});

  @override
  State<AllGroupsScreen> createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> with SingleTickerProviderStateMixin {
  final GroupsApiService _apiService = GroupsApiService();
  late TabController _tabController;
  late Future<GroupsResponse> _activeGroupsFuture;
  late Future<GroupsResponse> _closedGroupsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initial data fetch
    _refreshAllGroups();
  }

  // This method re-fetches the data for both tabs.
  Future<void> _refreshAllGroups() async {
    setState(() {
      _activeGroupsFuture = _apiService.fetchGroups(status: 1);
      _closedGroupsFuture = _apiService.fetchGroups(status: 0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/change-modified.jpg', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/your_appbar_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            toolbarHeight: 80,
            title: const Text('All Groups', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Closed'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                // "Active" tab
                GroupList(
                  groupsFuture: _activeGroupsFuture,
                  status: "active",
                  onRefresh: _refreshAllGroups,
                  onDataChanged: _refreshAllGroups,
                ),
                // "Closed" tab
                GroupList(
                  groupsFuture: _closedGroupsFuture,
                  status: "closed",
                  onRefresh: _refreshAllGroups,
                  onDataChanged: _refreshAllGroups,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- Helper Widget to Display the List of Groups ---
class GroupList extends StatelessWidget {
  final Future<GroupsResponse> groupsFuture;
  final String status;
  final Future<void> Function() onRefresh;
  final VoidCallback onDataChanged;

  const GroupList({
    super.key,
    required this.groupsFuture,
    required this.status,
    required this.onRefresh,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF1A1E57),
      child: FutureBuilder<GroupsResponse>(
        future: groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.groups.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Text(
                        "No $status groups found.",
                        style:  TextStyle(fontSize: 16, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          final groups = snapshot.data!.groups;
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return GroupCard(group: groups[index], onDataChanged: onDataChanged);
            },
          );
        },
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onDataChanged;

  const GroupCard({
    super.key,
    required this.group,
    required this.onDataChanged,
  });

  static final Map<String, String> _typeToIcon = {
    'Trip': 'assets/images/trip.png',
    'Room': 'assets/images/room.png',
    'Office': 'assets/images/office.png',
  };

  @override
  Widget build(BuildContext context) {
    final iconPath = _typeToIcon[group.type] ?? 'assets/images/default_group_icon.png';
    final isClosed = group.status == 0;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isClosed ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatedGroupPage(
                groupId: group.id,
                groupName: group.name,
                groupType: group.type,
                groupImage: iconPath,
                createdDate: DateFormat('MMM dd, yyyy').format(DateTime.parse(group.createdAt)),
              ),
            ),
          );

          if (result == true) {
            onDataChanged();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Opacity(
            opacity: isClosed ? 0.6 : 1.0,
            child: Row(
              children: [
                Image.asset(iconPath, width: 40, height: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        group.type,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

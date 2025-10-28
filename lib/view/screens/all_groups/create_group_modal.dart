// import 'package:expense_splitter/view/screens/all_groups/created_group_page.dart';
// import 'package:flutter/material.dart';

// // This function shows the main modal for creating a new group.
// void showCreateGroupModal(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // Important for the modal to not be covered by the keyboard
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       // Use a StatefulWidget for the modal's content to manage state
//       return const CreateGroupForm();
//     },
//   );
// }

// class CreateGroupForm extends StatefulWidget {
//   const CreateGroupForm({super.key});

//   @override
//   State<CreateGroupForm> createState() => _CreateGroupFormState();
// }

// class _CreateGroupFormState extends State<CreateGroupForm> {
//   final TextEditingController _groupNameController = TextEditingController();
//   String? _selectedType;
//   IconData? _selectedIcon;

//   // Data for the expense types
//   final Map<String, IconData> _expenseTypes = {
//     'Room': Icons.king_bed_outlined,
//     'Office': Icons.work_outline,
//     'Trip': Icons.flight_takeoff,
//   };

//   // This function shows the modal for selecting an expense type.
//   void _showTypeSelectionModal() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//             const Divider(height: 1),
//             // Create a list of RadioListTile widgets for selection
//             ..._expenseTypes.entries.map((entry) {
//               return RadioListTile<String>(
//                 title: Text(entry.key),
//                 value: entry.key,
//                 groupValue: _selectedType,
//                 secondary: Icon(entry.value),
//                 onChanged: (String? value) {
//                   if (value != null) {
//                     setState(() {
//                       _selectedType = value;
//                       _selectedIcon = _expenseTypes[value];
//                     });
//                     Navigator.pop(context); // Close the selection modal
//                   }
//                 },
//               );
//             }).toList(),
//             const SizedBox(height: 20),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _groupNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Padding to avoid the keyboard
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 20,
//         right: 20,
//         top: 20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Center(
//             child: Text(
//               'New Expense Group',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Expense Type Selector
//           const Text('Expense Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: _showTypeSelectionModal,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _selectedType ?? 'Select Type',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: _selectedType == null ?  Colors.grey : Colors.black,
//                     ),
//                   ),
//                   const Icon(Icons.arrow_drop_down, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Expense Group Name Field
//           const Text('Expense Group Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
//           TextField(
//             controller: _groupNameController,
//             decoration: const InputDecoration(
//               hintText: '  Enter group name',
//               hintStyle: TextStyle(color:Colors.grey ,fontSize: 16,)
//             ),
//           ),
//           const SizedBox(height: 30),

//           // Add Now Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: const Color(0xFF0D47A1), // Dark blue color
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onPressed: () {
//                 if (_groupNameController.text.isNotEmpty && _selectedType != null) {
//                   // Close the modal and navigate to the new page
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CreatedGroupPage(
//                         groupName: _groupNameController.text,
//                         groupType: _selectedType!,
//                         groupIcon: _selectedIcon!,
//                       ),
//                     ),
//                   );
//                 } else {
//                   // Show an error if fields are empty
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please fill all fields')),
//                   );
//                 }
//               },
//               child: const Text('Add Now', style: TextStyle(fontSize: 16, color: Colors.white)),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui'; // Import for ImageFilter
import 'package:expense_splitter/view/screens/all_groups/created_group_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

// This function shows the main modal for creating a new group.
void showCreateGroupModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Important for the modal to not be covered by the keyboard
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      // Use a StatefulWidget for the modal's content to manage state
      return const CreateGroupForm();
    },
  );
}

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({super.key});

  @override
  State<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final TextEditingController _groupNameController = TextEditingController();
  String? _selectedType;
  String? _selectedImage;

  // Data now holds image asset paths instead of IconData
  final Map<String, String> _expenseTypes = {
    'Room': 'assets/images/room.png',
    'Office': 'assets/images/office.png',
    'Trip': 'assets/images/trip.png',
  };

  // MODIFIED: This function now shows a blurred dialog with custom checkmark selection.
  void _showTypeSelectionDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Semi-transparent background
      builder: (BuildContext context) {
        // Use BackdropFilter for the blur effect
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.6), // Slightly transparent white
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            
            // MODIFIED: Content now uses a custom list item builder.
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: _expenseTypes.entries.map((entry) {
                final bool isSelected = _selectedType == entry.key;
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedType = entry.key;
                      _selectedImage = entry.value;
                    });
                    Navigator.of(context).pop(); // Close the dialog on selection
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Display the image
                            Image.asset(entry.value, width: 30, height: 30),
                            const SizedBox(width: 16),
                            // Display the type name
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.black : Colors.black, // Green text for selected item
                                ),
                              ),
                            ),
                            // Display the checkmark or circle icon
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? Colors.green.shade700 : Colors.grey, // Green icon for selected item
                              size: 22,
                            ),
                          ],
                          
                        ),
                        Divider()
                      ],
                    ),
                    
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Padding to avoid the keyboard
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'New Expense Group',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 24),

          // Expense Type Selector
          const Text('Expense Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showTypeSelectionDialog, // Call the dialog function
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Show the selected image next to the text
                      if (_selectedImage != null) ...[
                        Image.asset(_selectedImage!, width: 24, height: 24),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        _selectedType ?? 'Select Type',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedType == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Expense Group Name Field
          const Text('Expense Group Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
                hintText: '   Enter group name',
                hintStyle: TextStyle(color:Colors.grey ,fontSize: 16,),
                // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                // focusedBorder: OutlineInputBorder(borderSide: BorderSide(strokeAlign: BorderSide.strokeAlignOutside),
                // )
                
            ),
            
            
          ),
          const SizedBox(height: 30),

          // Add Now Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF0D47A1), // Dark blue color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
  if (_groupNameController.text.isNotEmpty && _selectedType != null) {
    // Get the current date and format it
    final String currentDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

    Navigator.pop(context); // Close the modal
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatedGroupPage(
          groupName: _groupNameController.text,
          groupType: _selectedType!,
          groupImage: _selectedImage!,
          // Pass the formatted date to the next page
          createdDate: currentDate, 
        ),
      ),
    );
  } else {
    // Show an error if fields are empty
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
  }
},
              child: const Text('Add Now', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

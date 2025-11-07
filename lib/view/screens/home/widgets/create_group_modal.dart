import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:expense_splitter/api/group_api_service.dart';
import 'package:expense_splitter/view/screens/home/created_group_page.dart';

void showCreateGroupModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
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
  bool _isLoading = false; // To show a loading indicator on the button

  // 3. Instantiate the new API service
  final GroupApiService _groupApiService = GroupApiService();

  final Map<String, String> _expenseTypes = {
    'Trip': 'assets/images/trip.png',
    'Room': 'assets/images/room.png',
    'Office': 'assets/images/office.png',
  };

  // --- API SUBMISSION LOGIC ---
  Future<void> _submitCreateGroup() async {
    // Validate inputs
    if (_groupNameController.text.isEmpty || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Call the API service
      final response = await _groupApiService.createGroup(
        userId: userId,
        name: _groupNameController.text,
        type: _selectedType!,
      );

      // Show success message and navigate
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        
        final String currentDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
        Navigator.pop(context); // Close the modal
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatedGroupPage(
              groupId: response.groupId,
              groupName: _groupNameController.text,
              groupType: _selectedType!,
              groupImage: _selectedImage!,
              createdDate: currentDate,
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  // --- UI Methods ---

  void _showTypeSelectionDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(entry.value, width: 30, height: 30),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? Colors.green.shade700 : Colors.grey,
                              size: 22,
                            ),
                          ],
                        ),
                        if (entry.key != _expenseTypes.keys.last) const Divider(height: 10, thickness: 1)
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text('New Expense Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(height: 24),

          // Expense Type Selector
          const Text('Expense Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showTypeSelectionDialog,
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
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Enter group name',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),

          // Add Now Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // Call the new _submitCreateGroup function
              onPressed: _isLoading ? null : _submitCreateGroup,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : const Text('Add Now', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}



// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:expense_splitter/api/group_api_service.dart';
// // Make sure to import the updated model
// import 'package:expense_splitter/model/group_create_model.dart';
// import 'package:expense_splitter/view/screens/all_groups/created_group_page.dart';

// void showCreateGroupModal(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
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
//   String? _selectedImage;
//   bool _isLoading = false;
//   final GroupApiService _groupApiService = GroupApiService();

//   final Map<String, String> _expenseTypes = {
//     'Trip': 'assets/images/trip.png',
//     'Room': 'assets/images/room.png',
//     'Office': 'assets/images/office.png',
//   };

//   // --- API SUBMISSION LOGIC (UPDATED) ---
//   Future<void> _submitCreateGroup() async {
//     if (_groupNameController.text.isEmpty || _selectedType == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt('userId');

//       if (userId == null) {
//         throw Exception("User not logged in");
//       }

//       // Call the API service
//       final response = await _groupApiService.createGroup(
//         userId: userId,
//         name: _groupNameController.text,
//         type: _selectedType!,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(response.message), backgroundColor: Colors.green),
//         );
        
//         final String currentDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
//         Navigator.pop(context); // Close the modal
        
//         // --- THE FIX ---
//         // Navigate to the CreatedGroupPage with the new groupId from the response
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CreatedGroupPage(
//               groupId: response.groupId, // <-- PASS THE GROUP ID HERE
//               groupName: _groupNameController.text,
//               groupType: _selectedType!,
//               groupImage: _selectedImage!,
//               createdDate: currentDate,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
  
//   // --- UI Methods (No changes needed below this line) ---
  
//   void _showTypeSelectionDialog() {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.5),
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: AlertDialog(
//             backgroundColor: Colors.white.withOpacity(0.8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             title: const Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: _expenseTypes.entries.map((entry) {
//                 final bool isSelected = _selectedType == entry.key;
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       _selectedType = entry.key;
//                       _selectedImage = entry.value;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset(entry.value, width: 30, height: 30),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Text(
//                                 entry.key,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                 ),
//                               ),
//                             ),
//                             Icon(
//                               isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
//                               color: isSelected ? Colors.green.shade700 : Colors.grey,
//                               size: 22,
//                             ),
//                           ],
//                         ),
//                         if (entry.key != _expenseTypes.keys.last) const Divider(height: 10, thickness: 1)
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
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
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 20, right: 20, top: 20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Center(
//             child: Text('New Expense Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//           ),
//           const SizedBox(height: 24),
//           const Text('Expense Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: _showTypeSelectionDialog,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       if (_selectedImage != null) ...[
//                         Image.asset(_selectedImage!, width: 24, height: 24),
//                         const SizedBox(width: 12),
//                       ],
//                       Text(
//                         _selectedType ?? 'Select Type',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: _selectedType == null ? Colors.grey : Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Icon(Icons.arrow_drop_down, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text('Expense Group Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
//           TextField(
//             controller: _groupNameController,
//             textCapitalization: TextCapitalization.words,
//             decoration: const InputDecoration(
//               hintText: 'Enter group name',
//               hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: const Color(0xFF0D47A1),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onPressed: _isLoading ? null : _submitCreateGroup,
//               child: _isLoading
//                   ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
//                   : const Text('Add Now', style: TextStyle(fontSize: 16, color: Colors.white)),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

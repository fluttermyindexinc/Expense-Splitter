// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/my_expenses_api_service.dart';
// import 'package:expense_splitter/model/my_expenses_model.dart';

// class MyExpensesScreen extends StatefulWidget {
//   const MyExpensesScreen({super.key});

//   @override
//   State<MyExpensesScreen> createState() => _MyExpensesScreenState();
// }

// class _MyExpensesScreenState extends State<MyExpensesScreen> {
//   final MyExpensesApiService _apiService = MyExpensesApiService();
//   final TextEditingController _searchController = TextEditingController();

//   // State for holding all data vs. filtered data
//   List<Expense> _allExpenses = [];
//   List<Expense> _filteredExpenses = [];
//   bool _isLoading = true;

//   // State for the filter values
//   DateTime? _fromDate;
//   DateTime? _toDate;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch all expenses once when the screen loads
//     _fetchAllExpenses();

//     // Add a listener to the search controller to filter as the user types
//     _searchController.addListener(() {
//       _applyFilters();
//     });
//   }

//   // --- Fetches all expenses from the API at once ---
//   Future<void> _fetchAllExpenses() async {
//     setState(() { _isLoading = true; });

//     try {
//       // Request a very large number to get all records.
//       // Your API must support this.
//       final response = await _apiService.fetchExpenses(page: 0, perPage: 10000); 

//       if (mounted) {
//         setState(() {
//           _allExpenses = response.expenses;
//           _applyFilters(); // Apply initial (empty) filters
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() { _isLoading = false; });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading expenses: $e')),
//         );
//       }
//     }
//   }
  
//   // --- Applies all currently selected filters to the master list ---
//   void _applyFilters() {
//     List<Expense> filtered = List.from(_allExpenses);

//     // Apply 'From Date' filter
//     if (_fromDate != null) {
//       filtered = filtered.where((expense) => 
//         !expense.createdAt.isBefore(_fromDate!)
//       ).toList();
//     }

//     // Apply 'To Date' filter
//     if (_toDate != null) {
//       filtered = filtered.where((expense) => 
//         !expense.createdAt.isAfter(_toDate!.add(const Duration(days: 1))) // Includes the entire 'to' day
//       ).toList();
//     }

//     // Apply search filter on the 'note' field
//     final searchQuery = _searchController.text.toLowerCase();
//     if (searchQuery.isNotEmpty) {
//       filtered = filtered.where((expense) => 
//         expense.note.toLowerCase().contains(searchQuery)
//       ).toList();
//     }

//     setState(() {
//       _filteredExpenses = filtered;
//     });
//   }

//   // --- Shows a date picker and triggers filtering ---
//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//         _applyFilters(); // Re-apply filters after date selection
//       });
//     }
//   }

//   // --- Function to clear the date filters ---
//   void _clearDateFilters() {
//     setState(() {
//       _fromDate = null;
//       _toDate = null;
//     });
//     // Re-apply filters, which will now show all items (respecting the search text)
//     _applyFilters();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/your_appbar_background.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         toolbarHeight: 80,
//         title: const Text('My Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
//         foregroundColor: Colors.white,
//         elevation: 10,
//       ),
//       body: Column(
//         children: [
//           // --- Filter UI Section ---
//           _buildFilterSection(),
          
//           // --- List View Section ---
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : RefreshIndicator(
//                     onRefresh: _fetchAllExpenses, // Pull-to-refresh re-fetches all data
//                     child: _filteredExpenses.isEmpty
//                         ? const Center(child: Text('No expenses match your filters.', style: TextStyle(fontSize: 18, color: Colors.grey)))
//                         : ListView.builder(
//                             padding: const EdgeInsets.only(bottom: 90), // Padding to avoid nav bar
//                             itemCount: _filteredExpenses.length,
//                             itemBuilder: (context, index) {
//                               final expense = _filteredExpenses[index];
//                               return _buildExpenseCard(expense);
//                             },
//                           ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Widget for the filter controls ---
//   Widget _buildFilterSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
//       color: Colors.white,
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(child: _buildDatePickerField(isFrom: true)),
//               const SizedBox(width: 10),
//               Expanded(child: _buildDatePickerField(isFrom: false)),
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Colors.blueAccent),
//                 tooltip: 'Clear Date Filters',
//                 onPressed: _clearDateFilters,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search by note...',
//               prefixIcon: const Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.grey[200],
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Reusable widget for date picker fields ---
//   Widget _buildDatePickerField({required bool isFrom}) {
//     DateTime? date = isFrom ? _fromDate : _toDate;
//     String label = isFrom ? 'From Date' : 'To Date';

//     return GestureDetector(
//       onTap: () => _selectDate(context, isFrom),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date == null ? label : DateFormat('MMM dd, yyyy').format(date),
//               style: TextStyle(
//                 color: date == null ? Colors.grey.shade600 : Colors.black,
//               ),
//             ),
//             const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseCard(Expense expense) {
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     expense.note,
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '₹${expense.amount}',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/my_expenses_api_service.dart';
// import 'package:expense_splitter/model/my_expenses_model.dart';

// class MyExpensesScreen extends StatefulWidget {
//   const MyExpensesScreen({super.key});

//   @override
//   State<MyExpensesScreen> createState() => _MyExpensesScreenState();
// }

// class _MyExpensesScreenState extends State<MyExpensesScreen> {
//   final MyExpensesApiService _apiService = MyExpensesApiService();
//   final TextEditingController _searchController = TextEditingController();

//   List<Expense> _allExpenses = [];
//   List<Expense> _filteredExpenses = [];
//   bool _isLoading = true;

//   DateTime? _fromDate;
//   DateTime? _toDate;

//   @override
//   void initState() {
//     super.initState();
//     _loopFetchAllExpenses();
//     _searchController.addListener(() {
//       _applyFilters();
//     });
//   }

//   Future<void> _loopFetchAllExpenses() async {
//     setState(() { _isLoading = true; });
    
//     List<Expense> allFetchedExpenses = [];
//     int currentPage = 0;
//     bool hasNextPage = true;

//     try {
//       while (hasNextPage) {
//         final response = await _apiService.fetchExpenses(page: currentPage);
//         allFetchedExpenses.addAll(response.expenses);
        
//         if (allFetchedExpenses.length >= response.total) {
//           hasNextPage = false;
//         } else {
//           currentPage++;
//         }
//       }

//       if (mounted) {
//         setState(() {
//           _allExpenses = allFetchedExpenses;
//           _applyFilters();
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() { _isLoading = false; });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading all expenses: $e')),
//         );
//       }
//     }
//   }
  
//   void _applyFilters() {
//     List<Expense> filtered = List.from(_allExpenses);

//     if (_fromDate != null) {
//       filtered = filtered.where((expense) => !expense.createdAt.isBefore(_fromDate!)).toList();
//     }

//     if (_toDate != null) {
//       filtered = filtered.where((expense) => !expense.createdAt.isAfter(_toDate!.add(const Duration(days: 1)))).toList();
//     }

//     final searchQuery = _searchController.text.toLowerCase();
//     if (searchQuery.isNotEmpty) {
//       filtered = filtered.where((expense) => expense.note.toLowerCase().contains(searchQuery)).toList();
//     }

//     setState(() {
//       _filteredExpenses = filtered;
//     });
//   }

//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//         _applyFilters();
//       });
//     }
//   }

//   void _clearDateFilters() {
//     setState(() {
//       _fromDate = null;
//       _toDate = null;
//     });
//     _applyFilters();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // --- IMPORTANT: Set Scaffold background to transparent ---
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/your_appbar_background.jpg'), // Keep your AppBar background
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         toolbarHeight: 80,
//         title: const Text('My Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
//         foregroundColor: Colors.white,
//         elevation: 10,
//       ),
//       // --- NEW: Using a Stack for the background image ---
//       body: Stack(
//         children: [
//           // --- Layer 1: The Background Image ---
//            Positioned.fill(
//             child: Image.asset(
//               "assets/images/change-modified.jpg", // <-- CHANGE THIS
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Container(
//           //   decoration: const BoxDecoration(
//           //     image: DecorationImage(
//           //       image: AssetImage("assets/images/change-modified.jpg"), // <-- CHANGE THIS TO YOUR IMAGE PATH
//           //       fit: BoxFit.cover,
//           //     ),
//           //   ),
//           // ),
//           // --- Layer 2: Your Content ---
//           Column(
//             children: [
//               _buildFilterSection(),
//               Expanded(
//                 child: _isLoading
//                     ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
//                     : RefreshIndicator(
//                         onRefresh: _loopFetchAllExpenses,
//                         child: _filteredExpenses.isEmpty
//                             ? const Center(
//                                 child: Text(
//                                   'No expenses match your filters.',
//                                   style: TextStyle(fontSize: 18, color: Colors.black45),
//                                 ),
//                               )
//                             : ListView.builder(
//                                 padding: const EdgeInsets.only(bottom: 90),
//                                 itemCount: _filteredExpenses.length,
//                                 itemBuilder: (context, index) {
//                                   final expense = _filteredExpenses[index];
//                                   return _buildExpenseCard(expense);
//                                 },
//                               ),
//                       ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Filter section widget ---
//   Widget _buildFilterSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
//       // Making the filter background semi-transparent to see the image behind it
//       color: Colors.white.withOpacity(0.5),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(child: _buildDatePickerField(isFrom: true)),
//               const SizedBox(width: 10),
//               Expanded(child: _buildDatePickerField(isFrom: false)),
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Color(0xFF1A1E57)),
//                 // icon: const Icon(Icons.refresh, color: Colors.white),

//                 tooltip: 'Clear Date Filters',
//                 onPressed: _clearDateFilters,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _searchController,
//             style: const TextStyle(color: Color(0xFF1A1E57)), // Text color for search input
//             decoration: InputDecoration(
//               hintText: 'Search by note...',
//               hintStyle: TextStyle(color: Color(0xFF1A1E57).withOpacity(0.7)),
//               prefixIcon: const Icon(Icons.search, color: Color(0xFF1A1E57)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.black.withOpacity(0.2),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Date picker field widget ---
//   Widget _buildDatePickerField({required bool isFrom}) {
//     DateTime? date = isFrom ? _fromDate : _toDate;
//     String label = isFrom ? 'From Date' : 'To Date';

//     return GestureDetector(
//       onTap: () => _selectDate(context, isFrom),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           // Adding transparency to the date fields
//           color: Colors.black.withOpacity(0.2),
//           border: Border.all(color: Colors.white.withOpacity(0.5)),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date == null ? label : DateFormat('MMM dd, yyyy').format(date),
//               style: TextStyle(
//                 color: date == null ? Color.fromARGB(216, 26, 30, 87) : Color(0xFF1A1E57),
//               ),
//             ),
//             const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1A1E57)),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Expense card widget ---
//   Widget _buildExpenseCard(Expense expense) {
//     return Card(
//       // Adding transparency to the cards
//       color: Colors.white.withOpacity(0.85),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     expense.note,
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '₹${expense.amount}',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
//               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// lib/view/screens/my_expenses/my_expenses.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/my_expenses_api_service.dart';
// import 'package:expense_splitter/model/my_expenses_model.dart';

// class MyExpensesScreen extends StatefulWidget {
//   const MyExpensesScreen({super.key});

//   @override
//   State<MyExpensesScreen> createState() => _MyExpensesScreenState();
// }

// class _MyExpensesScreenState extends State<MyExpensesScreen> {
//    final MyExpensesApiService _apiService = MyExpensesApiService();
//   final TextEditingController _searchController = TextEditingController();

//   List<Expense> _allExpenses = [];
//   List<Expense> _filteredExpenses = [];
//   bool _isLoading = true;

//   DateTime? _fromDate;
//   DateTime? _toDate;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAllExpenses();

//     _searchController.addListener(() {
//       _applyFilters();
//     });
//   }

//   Future<void> _fetchAllExpenses() async {
//     setState(() { _isLoading = true; });

//     try {
//       final response = await _apiService.fetchExpenses(page: 0, perPage: 10000);

//       if (mounted) {
//         setState(() {
//           _allExpenses = response.expenses;
//           _applyFilters(); // Apply initial (empty) filters
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() { _isLoading = false; });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading expenses: $e')),
//         );
//       }
//     }
//   }
  
//   void _applyFilters() {
//     List<Expense> filtered = List.from(_allExpenses);

//     if (_fromDate != null) {
//       filtered = filtered.where((expense) => 
//         !expense.createdAt.isBefore(_fromDate!)
//       ).toList();
//     }

//     if (_toDate != null) {
//       filtered = filtered.where((expense) => 
//         !expense.createdAt.isAfter(_toDate!.add(const Duration(days: 1)))
//       ).toList();
//     }

//     final searchQuery = _searchController.text.toLowerCase();
//     if (searchQuery.isNotEmpty) {
//       filtered = filtered.where((expense) => 
//         expense.note.toLowerCase().contains(searchQuery)
//       ).toList();
//     }

//     setState(() {
//       _filteredExpenses = filtered;
//     });
//   }

//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//         _applyFilters();
//       });
//     }
//   }

//   // --- NEW: Function to clear the date filters ---
//   void _clearDateFilters() {
//     setState(() {
//       _fromDate = null;
//       _toDate = null;
//     });
//     // Re-apply filters, which will now ignore the null dates
//     _applyFilters();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/your_appbar_background.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         toolbarHeight: 80,
//         title: const Text('My Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
//         foregroundColor: Colors.white,
//         elevation: 10,
//       ),
//       body: Column(
//         children: [
//           _buildFilterSection(),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : RefreshIndicator(
//                     onRefresh: _fetchAllExpenses,
//                     child: _filteredExpenses.isEmpty
//                         ? const Center(child: Text('No expenses match your filters.', style: TextStyle(fontSize: 18, color: Colors.grey)))
//                         : ListView.builder(
//                             padding: const EdgeInsets.only(bottom: 90),
//                             itemCount: _filteredExpenses.length,
//                             itemBuilder: (context, index) {
//                               final expense = _filteredExpenses[index];
//                               return _buildExpenseCard(expense);
//                             },
//                           ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Widget for the filter controls ---
//  Widget _buildFilterSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 12, 4, 12), // Adjusted padding
//       color: Colors.white,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: _buildDatePickerField(isFrom: true)),
//               const SizedBox(width: 10),
//               Expanded(child: _buildDatePickerField(isFrom: false)),
//               // --- NEW: Refresh button to clear dates ---
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Colors.blueAccent),
//                 tooltip: 'Clear Date Filters',
//                 onPressed: _clearDateFilters,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search by note...',
//               prefixIcon: const Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.grey[200],
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//   // --- Reusable widget for date picker fields ---
//   Widget _buildDatePickerField({required bool isFrom}) {
//     DateTime? date = isFrom ? _fromDate : _toDate;
//     String label = isFrom ? 'From Date' : 'To Date';

//     return GestureDetector(
//       onTap: () => _selectDate(context, isFrom),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date == null ? label : DateFormat('MMM dd, yyyy').format(date),
//               style: TextStyle(
//                 color: date == null ? Colors.grey.shade600 : Colors.black,
//               ),
//             ),
//             const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseCard(Expense expense) {
//     // This widget's code is unchanged
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     expense.note,
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '₹${expense.amount}',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// lib/view/screens/my_expenses/my_expenses.dart



// import 'package:expense_splitter/view/screens/my_expenses/widgets/pagination_controls.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/my_expenses_api_service.dart';
// import 'package:expense_splitter/model/my_expenses_model.dart';

// class MyExpensesScreen extends StatefulWidget {
//   const MyExpensesScreen({super.key});

//   @override
//   State<MyExpensesScreen> createState() => _MyExpensesScreenState();
// }

// class _MyExpensesScreenState extends State<MyExpensesScreen> {
//   final MyExpensesApiService _apiService = MyExpensesApiService();

//   List<Expense> _expenses = [];
//   int _currentPage = 1;
//   int _totalPages = 1;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchExpensesForPage(1);
//   }

//   Future<void> _fetchExpensesForPage(int page) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await _apiService.fetchExpenses(page: page - 1);
//       if (mounted) {
//         setState(() {
//           _expenses = response.expenses;
//           _currentPage = page;
//           _totalPages = (response.total / 10).ceil();
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching expenses: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/your_appbar_background.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         toolbarHeight: 80,
//         title: const Text('My Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
//         foregroundColor: Colors.white,
//         elevation: 10,
//       ),
//       // --- FIX: Wrap the body in Padding to avoid the bottom navigation bar ---
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 90.0), // Adjust this value if needed
//         child: Column(
//           children: [
//             Expanded(
//               child: _isLoading && _expenses.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : _expenses.isEmpty && !_isLoading
//                       ? const Center(child: Text('No expenses found.', style: TextStyle(fontSize: 18, color: Colors.grey)))
//                       : ListView.builder(
//                           itemCount: _expenses.length,
//                           itemBuilder: (context, index) {
//                             final expense = _expenses[index];
//                             return _buildExpenseCard(expense);
//                           },
//                         ),
//             ),
//             if (!_isLoading && _totalPages > 1)
//               PaginationControls(
//                 currentPage: _currentPage,
//                 totalPages: _totalPages,
//                 onPageChanged: (page) {
//                   _fetchExpensesForPage(page);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseCard(Expense expense) {
//     // This widget's code remains unchanged
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     expense.note,
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '₹${expense.amount}',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:expense_splitter/view/screens/my_expenses/widgets/pagination_controls.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/my_expenses_api_service.dart';
// import 'package:expense_splitter/model/my_expenses_model.dart';

// class MyExpensesScreen extends StatefulWidget {
//   const MyExpensesScreen({super.key});

//   @override
//   State<MyExpensesScreen> createState() => _MyExpensesScreenState();
// }

// class _MyExpensesScreenState extends State<MyExpensesScreen> {
//   final MyExpensesApiService _apiService = MyExpensesApiService();

//   List<Expense> _expenses = [];
//   int _currentPage = 1;
//   int _totalPages = 1;
//   bool _isLoading = true; // Start in a loading state

//   @override
//   void initState() {
//     super.initState();
//     _fetchExpensesForPage(1);
//   }

//   // --- THE FINAL FIX: Refined state management ---
//   Future<void> _fetchExpensesForPage(int page) async {
//     // Set loading state and immediately update the page number for the UI
//     setState(() {
//       _isLoading = true;
//       _currentPage = page;
//     });

//     try {
//       // API page index is 0-based, UI is 1-based
//       final response = await _apiService.fetchExpenses(page: page - 1);
//       if (mounted) {
//         setState(() {
//           _expenses = response.expenses; // Replace list with new page's data
//           _totalPages = (response.total / 10).ceil();
//           _isLoading = false; // Hide loader ONLY after data is ready
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false; // Hide loader on error
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching expenses: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//        appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/your_appbar_background.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         toolbarHeight: 80,
//         title: const Text('My Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
//         foregroundColor: Colors.white,
//         elevation: 10,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 90.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _expenses.isEmpty
//                       ? const Center(child: Text('No expenses found.', style: TextStyle(fontSize: 18, color: Colors.grey)))
//                       : ListView.builder(
//                           itemCount: _expenses.length,
//                           itemBuilder: (context, index) {
//                             final expense = _expenses[index];
//                             return _buildExpenseCard(expense);
//                           },
//                         ),
//             ),
//             // This condition now works correctly because _totalPages is maintained across builds.
//             if (_totalPages > 1)
//               PaginationControls(
//                 currentPage: _currentPage,
//                 totalPages: _totalPages,
//                 onPageChanged: (page) {
//                   _fetchExpensesForPage(page);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseCard(Expense expense) {
//     // This widget's code remains unchanged
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     expense.note,
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '₹${expense.amount}',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_splitter/api/my_expenses_api_service.dart';
// import 'package:expense_splitter/model/my_expenses_model.dart';

// class MyExpensesScreen extends StatefulWidget {
//   const MyExpensesScreen({super.key});

//   @override
//   State<MyExpensesScreen> createState() => _MyExpensesScreenState();
// }

// class _MyExpensesScreenState extends State<MyExpensesScreen> {
//   final MyExpensesApiService _apiService = MyExpensesApiService();
//   final TextEditingController _searchController = TextEditingController();

//   List<Expense> _allExpenses = [];
//   List<Expense> _filteredExpenses = [];
//   bool _isLoading = true;

//   DateTime? _fromDate;
//   DateTime? _toDate;

//   int _currentPage = 1;
//   int _totalPages = 1;
//   final int _perPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAllExpenses();
//     _searchController.addListener(() {
//       _applyFilters();
//     });
//   }

//   Future<void> _fetchAllExpenses() async {
//     setState(() => _isLoading = true);

//     List<Expense> allFetchedExpenses = [];
//     int currentPage = 0;
//     bool hasMorePages = true;

//     try {
//       while (hasMorePages) {
//         final response = await _apiService.fetchExpenses(page: currentPage);

//         if (response.expenses.isNotEmpty) {
//           allFetchedExpenses.addAll(response.expenses);
//           currentPage++;
//         } else {
//           hasMorePages = false;
//         }
//       }

//       if (mounted) {
//         setState(() {
//           _allExpenses = allFetchedExpenses;
//           _applyFilters();
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading all expenses: $e')),
//         );
//       }
//     }
//   }

//   void _applyFilters() {
//     List<Expense> filtered = List.from(_allExpenses);

//     if (_fromDate != null) {
//       filtered = filtered
//           .where((expense) => !expense.createdAt.isBefore(_fromDate!))
//           .toList();
//     }

//     if (_toDate != null) {
//       filtered = filtered
//           .where((expense) =>
//               !expense.createdAt.isAfter(_toDate!.add(const Duration(days: 1))))
//           .toList();
//     }

//     final searchQuery = _searchController.text.toLowerCase();
//     if (searchQuery.isNotEmpty) {
//       filtered = filtered
//           .where((expense) => expense.note.toLowerCase().contains(searchQuery))
//           .toList();
//     }

//     setState(() {
//       _filteredExpenses = filtered;
//       _totalPages = (_filteredExpenses.length / _perPage).ceil();
//       if (_totalPages == 0) {
//         _totalPages = 1;
//       }
//       if (_currentPage > _totalPages) {
//         _currentPage = _totalPages;
//       }
//     });
//   }

//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//         _applyFilters();
//       });
//     }
//   }

//   void _clearDateFilters() {
//     setState(() {
//       _fromDate = null;
//       _toDate = null;
//     });
//     _applyFilters();
//   }

//   void _onPageChanged(int page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final startIndex = (_currentPage - 1) * _perPage;
//     final endIndex = (startIndex + _perPage > _filteredExpenses.length)
//         ? _filteredExpenses.length
//         : startIndex + _perPage;
//     final paginatedExpenses = _filteredExpenses.sublist(startIndex, endIndex);

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image:
//                   AssetImage('assets/images/your_appbar_background.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         toolbarHeight: 80,
//         title: const Text('My Expenses',
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 22)),
//         foregroundColor: Colors.white,
//         elevation: 10,
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               "assets/images/change-modified.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             top: false,
//             bottom: true,
//             child: Column(
//               children: [
//                 _buildFilterSection(),
//                 Expanded(
//                   child: _isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(color: Colors.blueAccent))
//                       : RefreshIndicator(
//                           onRefresh: _fetchAllExpenses,
//                           child: _filteredExpenses.isEmpty
//                               ? const Center(
//                                   child: Text(
//                                     'No expenses match your filters.',
//                                     style: TextStyle(
//                                         fontSize: 18, color: Colors.black45),
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   itemCount: paginatedExpenses.length,
//                                   itemBuilder: (context, index) {
//                                     final expense = paginatedExpenses[index];
//                                     return _buildExpenseCard(expense);
//                                   },
//                                 ),
//                         ),
//                 ),
//                 if (!_isLoading && _totalPages > 1) _buildPaginationControls(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
//       color: Colors.white.withOpacity(0.5),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(child: _buildDatePickerField(isFrom: true)),
//               const SizedBox(width: 10),
//               Expanded(child: _buildDatePickerField(isFrom: false)),
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Color(0xFF1A1E57)),
//                 tooltip: 'Clear Date Filters',
//                 onPressed: _clearDateFilters,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _searchController,
//             style: const TextStyle(color: Color(0xFF1A1E57)),
//             decoration: InputDecoration(
//               hintText: 'Search by note...',
//               hintStyle:
//                   TextStyle(color: const Color(0xFF1A1E57).withOpacity(0.7)),
//               prefixIcon: const Icon(Icons.search, color: Color(0xFF1A1E57)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.black.withOpacity(0.2),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDatePickerField({required bool isFrom}) {
//     DateTime? date = isFrom ? _fromDate : _toDate;
//     String label = isFrom ? 'From Date' : 'To Date';

//     return GestureDetector(
//       onTap: () => _selectDate(context, isFrom),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.2),
//           border: Border.all(color: Colors.white.withOpacity(0.5)),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date == null ? label : DateFormat('MMM dd, yyyy').format(date),
//               style: TextStyle(
//                 color: date == null
//                     ? const Color.fromARGB(216, 26, 30, 87)
//                     : const Color(0xFF1A1E57),
//               ),
//             ),
//             const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1A1E57)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseCard(Expense expense) {
//     return Card(
//       color: Colors.white.withOpacity(0.85),
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     expense.note,
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '₹${expense.amount}',
//                   style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
//               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaginationControls() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       color: Colors.transparent,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildPageButton(
//             icon: Icons.chevron_left,
//             enabled: _currentPage > 1,
//             onTap: () => _onPageChanged(_currentPage - 1),
//           ),
//           const SizedBox(width: 10),
//           ..._generatePageNumbers().map((pageNumber) {
//             return pageNumber == -1
//                 ? _buildEllipsis()
//                 : _buildPageNumber(pageNumber);
//           }),
//           const SizedBox(width: 10),
//           _buildPageButton(
//             icon: Icons.chevron_right,
//             enabled: _currentPage < _totalPages,
//             onTap: () => _onPageChanged(_currentPage + 1),
//           ),
//         ],
//       ),
//     );
//   }

//   List<int> _generatePageNumbers() {
//     if (_totalPages <= 7) {
//       return List.generate(_totalPages, (index) => index + 1);
//     }

//     final List<int> pages = [];
//     if (_currentPage <= 4) {
//       pages.addAll([1, 2, 3, 4, 5, -1, _totalPages]);
//     } else if (_currentPage > _totalPages - 4) {
//       pages.addAll([
//         1,
//         -1,
//         _totalPages - 4,
//         _totalPages - 3,
//         _totalPages - 2,
//         _totalPages - 1,
//         _totalPages
//       ]);
//     } else {
//       pages.addAll(
//           [1, -1, _currentPage - 1, _currentPage, _currentPage + 1, -1, _totalPages]);
//     }
//     return pages;
//   }

//   Widget _buildPageNumber(int pageNumber) {
//     bool isCurrent = _currentPage == pageNumber;
//     return GestureDetector(
//       onTap: () => _onPageChanged(pageNumber),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: isCurrent ? Colors.blueAccent : Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           '$pageNumber',
//           style: TextStyle(
//             color: isCurrent ? Colors.white : Colors.black,
//             fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPageButton(
//       {required IconData icon,
//       required bool enabled,
//       required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: enabled ? onTap : null,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: enabled ? Colors.grey[200] : Colors.grey[400],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: enabled ? Colors.black : Colors.grey[600]),
//       ),
//     );
//   }

//   Widget _buildEllipsis() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: const Text('...'),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_splitter/api/my_expenses_api_service.dart';
import 'package:expense_splitter/model/my_expenses_model.dart';


class MyExpensesScreen extends StatefulWidget {
  const MyExpensesScreen({super.key});


  @override
  State<MyExpensesScreen> createState() => _MyExpensesScreenState();
}


class _MyExpensesScreenState extends State<MyExpensesScreen> {
  final MyExpensesApiService _apiService = MyExpensesApiService();
  final TextEditingController _searchController = TextEditingController();


  List<Expense> _allExpenses = [];
  List<Expense> _filteredExpenses = [];
  bool _isLoading = true;


  DateTime? _fromDate;
  DateTime? _toDate;


  int _currentPage = 1;
  int _totalPages = 1;
  final int _perPage = 10;


  @override
  void initState() {
    super.initState();
    _fetchAllExpenses();
    _searchController.addListener(() {
      _applyFilters();
    });
  }


  Future<void> _fetchAllExpenses() async {
    setState(() => _isLoading = true);


    List<Expense> allFetchedExpenses = [];
    int currentPage = 0;
    bool hasMorePages = true;


    try {
      while (hasMorePages) {
        final response = await _apiService.fetchExpenses(page: currentPage);


        if (response.expenses.isNotEmpty) {
          allFetchedExpenses.addAll(response.expenses);
          currentPage++;
        } else {
          hasMorePages = false;
        }
      }


      if (mounted) {
        setState(() {
          _allExpenses = allFetchedExpenses;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading all expenses: $e')),
        );
      }
    }
  }


  void _applyFilters() {
    List<Expense> filtered = List.from(_allExpenses);


    if (_fromDate != null) {
      filtered = filtered
          .where((expense) => !expense.createdAt.isBefore(_fromDate!))
          .toList();
    }


    if (_toDate != null) {
      filtered = filtered
          .where((expense) =>
              !expense.createdAt.isAfter(_toDate!.add(const Duration(days: 1))))
          .toList();
    }


    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((expense) => expense.note.toLowerCase().contains(searchQuery))
          .toList();
    }


    setState(() {
      _filteredExpenses = filtered;
      _totalPages = (_filteredExpenses.length / _perPage).ceil();
      if (_totalPages == 0) {
        _totalPages = 1;
      }
      if (_currentPage > _totalPages) {
        _currentPage = _totalPages;
      }
    });
  }


  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
        _applyFilters();
      });
    }
  }


  void _clearDateFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
    });
    _applyFilters();
  }


  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final startIndex = (_currentPage - 1) * _perPage;
    final endIndex = (startIndex + _perPage > _filteredExpenses.length)
        ? _filteredExpenses.length
        : startIndex + _perPage;
    final paginatedExpenses = _filteredExpenses.sublist(startIndex, endIndex);


    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
           image: DecorationImage(
                  image: AssetImage('assets/images/blueeee.jpg'),
                  fit: BoxFit.cover,
                ),
          ),
        ),
        elevation: 10,
        title: const Text(
          'My Expenses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20)
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(135.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDatePickerField(isFrom: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildDatePickerField(isFrom: false)),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Color(0xFF1A1E57),),
                        tooltip: 'Clear Date Filters',
                        onPressed: _clearDateFilters,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by note...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/change-modified.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            top: false,
            bottom: true,
            child: Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.blueAccent),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchAllExpenses,
                          child: _filteredExpenses.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No expenses match your filters.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: paginatedExpenses.length,
                                  itemBuilder: (context, index) {
                                    final expense = paginatedExpenses[index];
                                    return _buildExpenseCard(expense);
                                  },
                                ),
                        ),
                ),
                if (!_isLoading && _totalPages > 1) _buildPaginationControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDatePickerField({required bool isFrom}) {
    DateTime? date = isFrom ? _fromDate : _toDate;
    String label = isFrom ? 'From Date' : 'To Date';


    return GestureDetector(
      onTap: () => _selectDate(context, isFrom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null ? label : DateFormat('MMM dd, yyyy').format(date),
              style: TextStyle(
                color: Colors.white.withOpacity(date == null ? 0.7 : 1.0),
              ),
            ),
            const Icon(Icons.calendar_today, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }


  Widget _buildExpenseCard(Expense expense) {
    return Card(
      // color: Colors.white.withOpacity(0.85),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    expense.note,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '₹ ${expense.amount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(expense.createdAt)}',
              style: TextStyle(fontSize: 8, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPageButton(
            icon: Icons.chevron_left,
            enabled: _currentPage > 1,
            onTap: () => _onPageChanged(_currentPage - 1),
          ),
          const SizedBox(width: 10),
          ..._generatePageNumbers().map((pageNumber) {
            return pageNumber == -1
                ? _buildEllipsis()
                : _buildPageNumber(pageNumber);
          }),
          const SizedBox(width: 10),
          _buildPageButton(
            icon: Icons.chevron_right,
            enabled: _currentPage < _totalPages,
            onTap: () => _onPageChanged(_currentPage + 1),
          ),
        ],
      ),
    );
  }


  List<int> _generatePageNumbers() {
    if (_totalPages <= 7) {
      return List.generate(_totalPages, (index) => index + 1);
    }


    final List<int> pages = [];
    if (_currentPage <= 4) {
      pages.addAll([1, 2, 3, 4, 5, -1, _totalPages]);
    } else if (_currentPage > _totalPages - 4) {
      pages.addAll([
        1,
        -1,
        _totalPages - 4,
        _totalPages - 3,
        _totalPages - 2,
        _totalPages - 1,
        _totalPages
      ]);
    } else {
      pages.addAll([
        1,
        -1,
        _currentPage - 1,
        _currentPage,
        _currentPage + 1,
        -1,
        _totalPages
      ]);
    }
    return pages;
  }


  Widget _buildPageNumber(int pageNumber) {
    bool isCurrent = _currentPage == pageNumber;
    return GestureDetector(
      onTap: () => _onPageChanged(pageNumber),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFF1A1E57) : Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            color: isCurrent ? Colors.white : Colors.black,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }


  Widget _buildPageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey[400] : Colors.grey[500],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: enabled ? Colors.black : Colors.grey[600]),
      ),
    );
  }


  Widget _buildEllipsis() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: const Text('...'),
    );
  }
}

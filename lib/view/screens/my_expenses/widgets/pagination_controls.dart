// // lib/view/widgets/pagination_controls.dart

// import 'package:flutter/material.dart';

// class PaginationControls extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final Function(int) onPageChanged;

//   const PaginationControls({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPageChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Previous Button
//           TextButton(
//             onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
//             child: const Text('PREV'),
//           ),

//           // Page Numbers
//           ..._buildPageNumbers(),

//           // Next Button
//           TextButton(
//             onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
//             child: const Text('NEXT'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build the page number widgets
//   List<Widget> _buildPageNumbers() {
//     List<Widget> pageWidgets = [];
//     int maxPagesToShow = 5; // Show up to 5 page numbers at a time
//     int startPage = 1;
//     int endPage = totalPages;

//     if (totalPages > maxPagesToShow) {
//       startPage = (currentPage - 2).clamp(1, totalPages - maxPagesToShow + 1);
//       endPage = startPage + maxPagesToShow - 1;
//     }

//     for (int i = startPage; i <= endPage; i++) {
//       pageWidgets.add(_buildPageNumber(i));
//     }

//     return pageWidgets;
//   }

//   Widget _buildPageNumber(int page) {
//     bool isSelected = page == currentPage;
//     return GestureDetector(
//       onTap: () => onPageChanged(page),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: Text(
//           '$page',
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black54,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
// }

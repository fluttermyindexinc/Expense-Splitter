import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_splitter/api/expense_api_service.dart';

// This function shows the modal and passes the required callbacks
void showAddExpenseModal(BuildContext context, {required int groupId, required Function(Map<String, dynamic>) onExpenseAdded}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return AddExpenseForm(
        groupId: groupId,
        onExpenseAdded: onExpenseAdded,
      );
    },
  );
}

class AddExpenseForm extends StatefulWidget {
  final int groupId;
  final Function(Map<String, dynamic>) onExpenseAdded;

  const AddExpenseForm({
    super.key,
    required this.groupId,
    required this.onExpenseAdded,
  });

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _apiService = ExpenseApiService();
  bool _isLoading = false;

  Future<void> _submitExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final userName = prefs.getString('name') ?? 'Me';

      if (userId == null) {
        throw Exception("User ID not found. Please log in again.");
      }

      final amount = double.parse(_amountController.text);
      final note = _noteController.text;

      final response = await _apiService.createExpense(
        groupId: widget.groupId,
        note: note,
        userId: userId,
        amount: amount,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.green),
        );

        // Create a map for the new expense to update the UI instantly
        final newExpense = {
          'title': note,
          'payer': userName,
          'amount': _amountController.text,
          'date': 'Today',
        };
        
        widget.onExpenseAdded(newExpense); // Callback to update the parent screen
        Navigator.pop(context); // Close the modal
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add expense: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Add New Expense', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(height: 24),
          const Text('Expense Amount (₹)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),

            TextFormField(
              controller: _amountController,
              // decoration: const InputDecoration(labelText: 'Expense Amount (₹)'),
               decoration: const InputDecoration(
              hintText: 'Enter Amount here',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          const Text('Enter Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),

            TextFormField(
              controller: _noteController,
              // decoration: const InputDecoration(labelText: 'Enter Description'),
               decoration: const InputDecoration(
              hintText: 'Enter a Description',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _submitExpense,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Add Now', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

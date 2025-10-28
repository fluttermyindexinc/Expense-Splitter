import 'package:expense_splitter/view/screens/all_groups/todo_list.dart';
import 'package:expense_splitter/view/screens/all_groups/widgets/add_task_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatedGroupPage extends StatelessWidget {
  final String groupName;
  final String groupType;
  final String groupImage;
  final String createdDate;

  const CreatedGroupPage({
    super.key,
    required this.groupName,
    required this.groupType,
    required this.groupImage,
    required this.createdDate,
  });

  @override
  Widget build(BuildContext context) {
    // --- Data for the detailed expenses list ---
    final List<Map<String, dynamic>> detailedExpenses = [
      {
        // 'icon': CupertinoIcons.car_detailed,
        // 'iconBackgroundColor': Colors.amber.shade100,
        'title': 'Cab to Hotel',
        'payer': 'Aditi',
        'amount': '1,200',
        'date': 'Dec 31',
      },
      {
        // 'icon': CupertinoIcons.bed_double_fill,
        // 'iconBackgroundColor': Colors.orange.shade100,
        'title': 'Hotel Stay',
        'payer': 'Kristien (Me)',
        'amount': '3,000',
        'date': 'Dec 31',
      },
      {
        // 'icon': CupertinoIcons.ant_fill,
        // 'iconBackgroundColor': Colors.red.shade100,
        'title': 'Lunch @ Fisherman\'s Wharf',
        'payer': 'Kiran',
        'amount': '1,250',
        'date': 'Dec 31',
      },
      {
        // 'icon': Icons.two_wheeler,
        // 'iconBackgroundColor': Colors.blue.shade100,
        'title': 'Scooty Rentals',
        'payer': 'Shared',
        'amount': '1,000',
        'date': 'Dec 31',
      },
    ];

    return Stack(
      children: [
        // Layer 1: The main page background
        Positioned.fill(
          child: Image.asset(
            'assets/images/change-modified.jpg', // YOUR MAIN BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),

        // Layer 2: The UI Content
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAppBar(context),
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildActionsGrid(context),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 12),

                    // This Row lays out the summary cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildExpenseInfoCard(
                          title: 'Total Expenses',
                          amount: '₹ 940.00',
                          icon: Icons.receipt_long,
                          iconColor: Colors.green.shade400,
                          backgroundImage:
                              'assets/images/total_expenses_background.jpg',
                        ),
                        _buildExpenseInfoCard(
                          title: 'Expense Per Person',
                          amount: '₹ 313.33',
                          icon: Icons.person,
                          iconColor: Colors.blueAccent.shade700,
                          backgroundImage:
                              'assets/images/paid_by_me_background.jpg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // The ExpenseDetailsSection
                    ExpenseDetailsSection(
                      owedAmount: '560',
                      expenses: detailedExpenses,
                    ),
                    const SizedBox(height: 24),

                    // "Group Members" header and card
                    const Text(
                      'Group Members',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMemberCard(
                      name: 'Afthab',
                      id: 'EXPS0040',
                      isAdmin: true,
                      amount: '0',
                    ),
                    const SizedBox(height: 40), // Spacing before the button
                    // *** MODIFIED: The "Close Group" button is now here ***
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Close Group',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing at the very bottom
                  ],
                ),
              ),
            ),
          ),
          // *** MODIFIED: The bottomNavigationBar has been removed ***
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        GestureDetector(
          onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TodoListPage()),
            );
          },
          child: Column(
            children: [
              Icon(
                Icons.note_alt,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2)],
              ),
              Text(
                'Todo-List',
                style: TextStyle(
                  shadows: [Shadow(blurRadius: 2)],
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(groupImage, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              ': $groupType',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          groupName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Created on $createdDate',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: 0.8,
      children: [
        _buildActionItem(
          onTap:() {
            
          },
          label: 'Add Expense',
          imagePath: 'assets/images/addition1.png',
        ),
        _buildActionItem(
          label: 'Todo',
          imagePath: 'assets/images/bill.png',
          onTap: () async {
            // 1. Show the dialog to add a task
            final newTask = await showAddTaskDialog(context);
            // 2. If a task was added, navigate to the TodoListPage with it
            if (newTask != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoListPage(initialTask: newTask),
                ),
              );
            }
          },
        ),
        _buildActionItem(
          onTap:() {
            
          } ,
          label: 'Invite User',
          imagePath: 'assets/images/invite.png',
        ),
        _buildActionItem(
          onTap: () {
            
          },
          label: 'via WhatsApp',
          imagePath: 'assets/images/whatsApp.png',
        ),
      ],
    );
  }

  Widget _buildActionItem({required String label, required String imagePath,required VoidCallback onTap,}) {
    return GestureDetector(
      onTap:onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseInfoCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required String backgroundImage,
  }) {
    return Material(
      elevation: 8.0,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: 165,
        height: 140,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            Icon(icon, color: iconColor, size: 28),
            Text(
              amount,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard({
    required String name,
    required String id,
    required bool isAdmin,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(239, 255, 255, 255).withOpacity(0.86),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/profile_pic.jpeg'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name - [$id]',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (isAdmin)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade900,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Text(
            '₹ $amount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseDetailsSection extends StatelessWidget {
  final String owedAmount;
  final List<Map<String, dynamic>> expenses;

  const ExpenseDetailsSection({
    super.key,
    required this.owedAmount,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 255, 255, 255).withOpacity(0.86),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Detailed List" title
          const Text(
            'Detailed List :',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // "You're owed" banner
          _buildOwedInfoBar(owedAmount: owedAmount),
          const SizedBox(height: 24),
          // "Detailed List" title
          // const Text(
          //   'Detailed List',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black87,
          //   ),
          // ),
          // const SizedBox(height: 16),
          // Dynamically create the list of expenses
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return _buildDetailedExpenseItem(
                // icon: expense['icon'],
                // iconBackgroundColor: expense['iconBackgroundColor'],
                title: expense['title'],
                payer: expense['payer'],
                amount: expense['amount'],
                date: expense['date'],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }

  // Helper widget for the green "You're owed" banner
  Widget _buildOwedInfoBar({required String owedAmount}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paid by me : ₹ 470',
            style: TextStyle(
              fontSize: 19,
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, color: Colors.green.shade900),
                  children: [
                    const TextSpan(text: "You're owed "),
                    TextSpan(
                      text: "₹ $owedAmount",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Text('Nudge', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 5),
                    Icon(CupertinoIcons.arrow_up_right, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedExpenseItem({
    // required IconData icon,
    // required Color iconBackgroundColor,
    required String title,
    required String payer,
    required String amount,
    required String date,
  }) {
    return Row(
      children: [
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: iconBackgroundColor,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Icon(icon, color: Colors.black54, size: 28),
        // ),
        // const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Paid by $payer',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹ $amount',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}

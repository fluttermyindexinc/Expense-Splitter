import 'package:expense_splitter/view/screens/all_groups/create_group_modal.dart';
import 'package:flutter/material.dart';

class AllGroupScreen extends StatelessWidget {
  // FIX: Add a key to receive from the parent (MainScreen).
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AllGroupScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/change-modified.jpg', // YOUR IMAGE PATH
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context), // Pass context to header
                    const SizedBox(height: 24),
                    _buildTotalBalanceCard(),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildActiveGroupsCard(),
                    const SizedBox(height: 24),
                    _buildClosedGroupsCard(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // FIX: Update _buildHeader to use the scaffoldKey to open the drawer.
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ... (User info remains the same)
        const Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/profile_pic.jpeg'),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      shadows: [Shadow(blurRadius: 2)]),
                ),
                Text(
                  'Kristien',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [Shadow(blurRadius: 2)],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  size: 28, 
            color: Colors.white,
            shadows: [Shadow(blurRadius: 2)],),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu, size: 28,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 2)],),
              // This opens the drawer when the menu icon is tapped.
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
          ],
        ),
      ],
    );
  }
  // ... (All other helper methods like _buildTotalBalanceCard, etc. remain unchanged)
  Widget _buildTotalBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/balance.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            '₹ -247.67',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            'You owe ₹247.67',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        //  MODIFIED: Wrapped with GestureDetector to make it tappable
        Expanded(
          child: GestureDetector(
            onTap: () => showCreateGroupModal(context), // <<< THIS OPENS THE MODAL
            child: _buildActionItem(
              icon: Icons.add_circle_outline,
              label: 'New group',
              imagePath: 'assets/images/greyy.png',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionItem(
            icon: Icons.receipt_long_outlined,
            label: 'My Expense',
            imagePath: 'assets/images/redd.png',
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(
      {required IconData icon,
      required String label,
      required String imagePath}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveGroupsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(239, 255, 255, 255).withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Groups',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          _buildGroupItem(
            icon: Icons.flight_takeoff,
            title: 'Maldives gang trip',
            subtitle: 'You owe',
            amount: '-247.67',
            amountColor: Colors.red,
          ),
          const Divider(height: 24, indent: 60),
          _buildGroupItem(
            icon: Icons.work_outline,
            title: 'Outing - office',
            subtitle: 'all settled',
            amount: '0',
            amountColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: Icon(icon, color: const Color.fromARGB(224, 42, 41, 41))),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: amountColor,
          ),
        ),
      ],
    );
  }

  Widget _buildClosedGroupsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 255, 255, 255).withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Closed groups',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Closed not available',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

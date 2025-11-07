import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_splitter/api/sliders_api_service.dart';
import 'package:expense_splitter/model/slider_model.dart';
import 'package:expense_splitter/view/screens/home/widgets/create_group_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

   final VoidCallback onNavigateToMyExpenses;

   final String userName;
  final String? fullDpUrl;

  const HomeScreen({super.key, required this.scaffoldKey,required this.onNavigateToMyExpenses, required this.userName,
    this.fullDpUrl,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SlidersApiService _slidersApiService = SlidersApiService();
  late Future<SliderResponse> _slidersFuture;

  // String _userName = 'Hello!';
  // String? _fullDpUrl; 

  @override
  void initState() {
    super.initState();
    // Fetch the sliders when the screen is first initialized.
    _slidersFuture = _slidersApiService.fetchSliders();
    // _loadUserData();
  }

  //  Future<void> _loadUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //    final String dpBaseUrl = dotenv.env['DP_IMAGE_URL'] ?? '';

  //   // 2. Get the user-specific filename from SharedPreferences
  //   final String? dpFileName = prefs.getString('dp');
  //   setState(() {
  //     _userName = prefs.getString('name') ?? 'User';
  //     if (dpFileName != null && dpFileName.isNotEmpty) {
  //       _fullDpUrl = '$dpBaseUrl/$dpFileName';
  //     }
  //   });
  // }
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
                    _buildHeader(context, name: widget.userName, dpUrl: widget.fullDpUrl),
                    const SizedBox(height: 24),
                    _buildTotalBalanceCard(),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildAdSlider(),
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

  Widget _buildAdSlider() {
    return FutureBuilder<SliderResponse>(
      future: _slidersFuture,
      builder: (context, snapshot) {
        // Show a loading indicator while fetching data.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 110,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // If there's an error or no data, show nothing.
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.sliders.isEmpty) {
          return const SizedBox.shrink(); // An empty box
        }

        // If data is available, build the CarouselSlider.
        final List<String> sliderImages = snapshot.data!.sliders;
        
        return CarouselSlider.builder(
          itemCount: sliderImages.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = sliderImages[index];

            
            return Container(
              // margin: EdgeInsets.symmetric(vertical: 10),
              // padding: EdgeInsets.only(top: 7 ,bottom: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: .01,
                    blurRadius:1000, 
                    offset: const Offset(0, 0), 
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity, 
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 115,
            autoPlay: true, 
            autoPlayInterval: const Duration(seconds: 4), 
            enlargeCenterPage: true, 
            viewportFraction: 1.0, 
            aspectRatio: 16 / 9,
          ),
        );
      },
    );
  }

  
  // Widget _buildHeader(BuildContext context, {required String name, String? dpUrl}) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           CircleAvatar(
  //             radius: 28,
  //             backgroundColor: Colors.grey.shade300,
  //             // Display network image if URL exists, otherwise a placeholder
  //             backgroundImage: dpUrl != null && dpUrl.isNotEmpty
  //                 ? NetworkImage(dpUrl)
  //                 : const AssetImage('assets/images/profile_pic.jpeg') as ImageProvider,
  //           ),
  //           const SizedBox(width: 12),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Hello!',
  //                 style: TextStyle(fontSize: 16, color: Colors.black, shadows: [Shadow(blurRadius: 2)]),
  //               ),
  //               Text(
  //                 name, // Display the loaded name
  //                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(blurRadius: 2)]),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           IconButton(icon: const Icon(Icons.notifications_none, size: 28, color: Colors.white, shadows: [Shadow(blurRadius: 2)]), onPressed: () {}),
  //           IconButton(
  //             icon: const Icon(Icons.menu, size: 28, color: Colors.white, shadows: [Shadow(blurRadius: 2)]),
  //             onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildHeader(BuildContext context, {required String name, String? dpUrl}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: dpUrl != null && dpUrl.isNotEmpty
                  ? NetworkImage(dpUrl)
                  : const AssetImage('assets/images/profile_pic.jpeg') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello!',
                  style: TextStyle(fontSize: 16, color: Colors.black, shadows: [Shadow(blurRadius: 2)]),
                ),
                Text(
                  name, // Use the passed name
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(blurRadius: 2)]),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.notifications_none, size: 28, color: Colors.white, shadows: [Shadow(blurRadius: 2)]), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.menu, size: 28, color: Colors.white, shadows: [Shadow(blurRadius: 2)]),
              onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
            ),
          ],
        ),
      ],
    );
  }

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
            blurRadius: 6,
            offset: const Offset(0, 2),
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
    // --- Wrap the Row with IntrinsicHeight ---
    // This forces all children in the Row to have the same height.
    return IntrinsicHeight(
      child: Row(
        // We no longer need CrossAxisAlignment.stretch here
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => showCreateGroupModal(context),
              child: _buildActionItem(
                icon: Icons.add_circle_outline,
                label: 'New group',
                imagePath: 'assets/images/greyy.png',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: widget.onNavigateToMyExpenses,
              child: _buildActionItem(
                icon: Icons.receipt_long_outlined,
                label: 'My Expense',
                imagePath: 'assets/images/redd.png',
              ),
            ),
          ),
        ],
      ),
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
            blurRadius: 6,
            offset: const Offset(0, 2),
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

import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:expense_splitter/api/expense_delete_service.dart';
import 'package:expense_splitter/api/group_edit_service.dart';
import 'package:expense_splitter/api/settings_api_service.dart';
import 'package:expense_splitter/api/sliders_api_service.dart';
import 'package:expense_splitter/model/settings_model.dart';
import 'package:expense_splitter/model/slider_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:expense_splitter/api/group_details_api_service.dart';
import 'package:expense_splitter/model/group_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_splitter/view/screens/home/todo_list.dart';
import 'package:expense_splitter/view/screens/home/widgets/add_expense_modal.dart';
import 'package:expense_splitter/view/screens/home/widgets/add_task_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CreatedGroupPage extends StatefulWidget {
  final int groupId;
  final String groupName;
  final String groupType;
  final String groupImage;
  final String createdDate;

  const CreatedGroupPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupType,
    required this.groupImage,
    required this.createdDate,
  });

  @override
  State<CreatedGroupPage> createState() => _CreatedGroupPageState();
}

class _CreatedGroupPageState extends State<CreatedGroupPage> {
  // final currencyFormat = NumberFormat("#,##0.00", "en_US");

  final SlidersApiService _slidersApiService = SlidersApiService();
  late Future<SliderResponse> _slidersFuture;

  final SettingsApiService _settingsService = SettingsApiService();
  AppSettings? _appSettings;
  bool _isSettingsLoading = true;

  final GroupDetailsService _detailsService = GroupDetailsService();
  late Future<GroupDetailsResponse> _groupDetailsFuture;
  //edit adpi
  final GroupsApiEditService _groupsApiEditService = GroupsApiEditService();

  bool _isClosed = false;
  bool _isInitialized =
      false; // Prevents re-initializing _isClosed on every rebuild
  bool _isLoading = false; // Tracks the API call for the button
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _groupDetailsFuture = _detailsService.fetchGroupDetails(widget.groupId);
    _slidersFuture = _slidersApiService.fetchSliders();
    //--------------------------------
    _fetchAppSettings();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentUserId = prefs.getInt('userId');
      });
    }
  }

  bool _isCurrentUserAdmin(List<Member> members) {
    if (_currentUserId == null) {
      return false; // Can't be admin if user ID is not loaded
    }
    try {
      // Find the member in the list whose ID matches the logged-in user's ID
      final currentUserAsMember = members.firstWhere(
        (member) => member.id == _currentUserId,
      );
      // Return their admin status
      return currentUserAsMember.isAdmin;
    } catch (e) {
      // If firstWhere fails, it means the user is not in the list.
      return false;
    }
  }

  //edit confirmation
  Future<bool?> _showConfirmationDialog(
    BuildContext context, {
    required bool isClosing,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(isClosing ? 'Confirm Close' : 'Confirm Reopen'),
          content: Text(
            isClosing
                ? 'Are you sure you want to close this group?'
                : 'Are you sure you want to reopen this group?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF1A1E57)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFFF013A)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleGroupStatusChange() async {
    final bool isClosingAction =
        !_isClosed; // Determine the action based on current state
    final bool? confirmed = await _showConfirmationDialog(
      context,
      isClosing: isClosingAction,
    );

    if (confirmed != true) return; // User cancelled the dialog

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch user ID from SharedPreferences (best practice)
      final prefs = await SharedPreferences.getInstance();
      final userId =
          prefs.getInt('userId') ?? 0; // Replace with your actual key

      if (userId == 0) {
        throw Exception("User not logged in.");
      }

      final response = await _groupsApiEditService.updateGroupStatus(
        groupId: widget.groupId,
        status: isClosingAction ? 0 : 1, // 0 to close, 1 to open
        userId: userId,
      );

      if (response.status == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
        // Pop the screen and return 'true' to signal a data change to the previous screen
        Navigator.of(context).pop(true);
      } else {
        throw Exception('API Error: ${response.message}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onExpenseAdded(Map<String, dynamic> newExpense) {
    setState(() {
      _groupDetailsFuture = _detailsService.fetchGroupDetails(widget.groupId);
      // _fetchAppSettings();
    });
  }

  Future<void> _fetchAppSettings() async {
    try {
      final settings = await _settingsService.fetchSettings();
      if (mounted) {
        setState(() {
          _appSettings = settings;
          _isSettingsLoading = false; // Settings are loaded
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSettingsLoading = false; // Stop loading even if there's an error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not load app settings for sharing.")),
        );
      }
      print("Failed to fetch settings for sharing: $e");
    }
  }

  Future<void> _shareViaWhatsApp(Group group) async {
    if (_isSettingsLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still loading settings, please wait...')),
      );
      return;
    }

    final playStoreLink = _appSettings?.playStore;
    final inviteLink = group.link; // Use the link from the API response

    if (playStoreLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get app link for sharing.')),
      );
      return;
    }

    final message =
        "Join My Group on Expense Splitter\n$playStoreLink\n\nClick to join: $inviteLink";
    final url = "whatsapp://send?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp is not installed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/change-modified.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: FutureBuilder<GroupDetailsResponse>(
              future: _groupDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No group data found.',
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  );
                }

                final group = snapshot.data!.group;
                //button visible --- admin true - button should be shown
                final bool showAdminButton = _isCurrentUserAdmin(group.members);

                if (!_isInitialized) {
                  _isClosed = group.status == 0;
                  // _checkAdminStatus(group.members);  // addded button visibility pnly if the admin is true
                  _isInitialized = true;
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _groupDetailsFuture = _detailsService.fetchGroupDetails(
                        widget.groupId,
                      );
                    });
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAppBar(context),
                          const SizedBox(height: 2),
                          _buildHeader(group),
                          const SizedBox(height: 10),

                          // This content is only shown when the group is active
                          _buildActionsGrid(context, group),
                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 12),
                          TotalFinancialCard(group: group),
                          const SizedBox(height: 24),
                          ExpenseDetailsSection(expenses: group.expenses),
                          const SizedBox(height: 24),
                          _buildAdSlider(),

                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Icon(
                                CupertinoIcons.person_3_fill,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Group Members :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: group.members.length,
                            itemBuilder: (context, index) {
                              final member = group.members[index];
                              return _buildMemberCard(member: member);
                            },
                          ),
                          const SizedBox(height: 40),
                          // ElevatedButton.icon(
                          //   onPressed: _isLoading
                          //       ? null
                          //       : _handleGroupStatusChange,
                          //   icon: _isLoading
                          //       ? Container(
                          //           // Show a spinner when loading
                          //           width: 24,
                          //           height: 24,
                          //           padding: const EdgeInsets.all(2.0),
                          //           child: const CircularProgressIndicator(
                          //             color: Colors.white,
                          //             strokeWidth: 3,
                          //           ),
                          //         )
                          //       : Icon(
                          //           _isClosed
                          //               ? Icons.lock_open
                          //               : Icons.power_settings_new,
                          //           color: Colors.white,
                          //         ),
                          //   label: Text(
                          //     _isClosed ? 'Reopen Group' : 'Close Group',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: _isClosed
                          //         ? Colors.green.shade800
                          //         : Colors.red[900], // Toggle color
                          //     padding: const EdgeInsets.symmetric(vertical: 16),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     textStyle: const TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 16,
                          //     ),
                          //   ),
                          // ),
                          if (showAdminButton)
                            ElevatedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : _handleGroupStatusChange,
                              icon: _isLoading
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Icon(
                                      _isClosed
                                          ? Icons.lock_open
                                          : Icons.power_settings_new,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                _isClosed ? 'Reopen Group' : 'Close Group',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isClosed
                                    ? Colors.green.shade800
                                    : Colors.red[900],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.sliders.isEmpty) {
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
                    blurRadius: 1000,
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

  // --- WIDGET BUILD METHODS ---

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TodoListPage()),
          ),
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

  Widget _buildHeader(Group group) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     Image.asset(widget.groupImage, width: 20, height: 20),
          //     const SizedBox(width: 8),
          //     Text(': ${widget.groupType}', style: const TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold)),
          //   ],
          // ),
          // const SizedBox(height: 8),
          Text(
            group.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Image.asset(widget.groupImage, width: 20, height: 20),
              const SizedBox(width: 3),
              Text(
                ': ${widget.groupType}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 76, 74, 74),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            'Created on ${widget.createdDate}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsGrid(BuildContext context, Group group) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      children: [
        _buildActionItem(
          onTap: () {
            showAddExpenseModal(
              context,
              groupId: widget.groupId,
              onExpenseAdded: _onExpenseAdded,
            );
          },
          label: 'Add Expense',
          imagePath: 'assets/images/addition1.png',
        ),
        _buildActionItem(
          label: 'Todo',
          imagePath: 'assets/images/bill.png',
          onTap: () async {
            final newTask = await showAddTaskDialog(context);
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
          onTap: () {},
          label: 'Invite User',
          imagePath: 'assets/images/invite.png',
        ),
        _buildActionItem(
          onTap: () => _shareViaWhatsApp(group),
          label: 'via WhatsApp',
          imagePath: 'assets/images/whatsApp.png',
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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

  // Widget _buildExpenseInfoCard({
  //   required String title,
  //   required String amount,
  //   required IconData icon,
  //   required Color iconColor,
  //   required String backgroundImage,
  // }) {
  //   return Material(
  //     elevation: 8.0,
  //     color: Colors.transparent,
  //     borderRadius: BorderRadius.circular(20.0),
  //     child: Container(
  //       width: 165,
  //       height: 140,
  //       padding: const EdgeInsets.all(16.0),
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage(backgroundImage),
  //           fit: BoxFit.cover,
  //         ),
  //         borderRadius: BorderRadius.circular(20.0),
  //         border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.white,
  //               shadows: [
  //                 Shadow(
  //                   blurRadius: 2.0,
  //                   color: Colors.black.withOpacity(0.5),
  //                   offset: const Offset(1.0, 1.0),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Icon(icon, color: iconColor, size: 32),
  //           Text(
  //             amount,
  //             style: TextStyle(
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //               shadows: [
  //                 Shadow(
  //                   blurRadius: 2.0,
  //                   color: Colors.black.withOpacity(0.5),
  //                   offset: const Offset(1.0, 1.0),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMemberCard({required Member member}) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(239, 255, 255, 255).withOpacity(0.86),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(member.profileImage),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${member.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '[${member.username}]',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      if (member.isAdmin)
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
                '₹ ${currencyFormat.format(member.balance)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearPercentIndicator(
            lineHeight: 6.0,
            percent: member.paidPercentage / 100.0,
            backgroundColor: Colors.grey[300],
            progressColor: Colors.blueAccent,
            barRadius: const Radius.circular(4),
            trailing: Text(
              "${member.paidPercentage.toStringAsFixed(0)}%",
              style: TextStyle(color: Colors.blueAccent, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseDetailsSection extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseDetailsSection({super.key, required this.expenses});

  @override
  State<ExpenseDetailsSection> createState() => _ExpenseDetailsSectionState();
}

class _ExpenseDetailsSectionState extends State<ExpenseDetailsSection> {
  late List<Expense> _localExpenses;
  final ExpenseDeleteService _deleteService = ExpenseDeleteService();
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _localExpenses = List.from(widget.expenses);
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Use 'userId' as the key, matching what you saved during login
    final id = prefs.getInt('userId');
    if (mounted) {
      setState(() {
        _currentUserId = id;
      });
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(Expense expense) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // title: const Text("Confirm Delete"),
          // content: Text("Are you sure you want to delete '${expense.note}'?",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
          content: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 15, color: Colors.black),
              children: [
                const TextSpan(text: "Are you sure you want to delete "),
                TextSpan(
                  text: "'${expense.note}'",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: "?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Close",
                style: TextStyle(color: Color(0xFFFF013A)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "OK",
                style: TextStyle(color: Color(0xFF1A1E57)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteExpense(int index, Expense expense) async {
    try {
      final response = await _deleteService.deleteExpense(expense.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
        if (response.status == 200) {
          setState(() {
            _localExpenses.removeAt(index);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to delete expense: $e")));
      }
    }
  }

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
          Row(
            children: [
              Icon(CupertinoIcons.creditcard, color: Colors.blueAccent),

              SizedBox(width: 4),
              const Text(
                'Expense List:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_localExpenses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/paper.png', width: 80),
                    const SizedBox(height: 8),
                    const Text(
                      'No expenses yet.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const Text(
                      'Tap "Add Expense" to get started.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _localExpenses.length,
              itemBuilder: (context, index) {
                final expense = _localExpenses[index];
                final bool isOwner = expense.user.id == _currentUserId;

                // --- Replace Dismissible with Slidable ---
                return ClipRRect(
                  child: Slidable(
                    key: Key(expense.id.toString()),
                    // Action pane that appears when swiping from the right
                    endActionPane: isOwner
                        ? ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  final confirm =
                                      await _showDeleteConfirmationDialog(
                                        expense,
                                      );
                                  if (confirm == true) {
                                    await deleteExpense(index, expense);
                                  }
                                },
                                backgroundColor: Colors.red[800]!,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_outline,
                                // label: 'Delete',
                              ),
                            ],
                          )
                        : null,
                    // The main content of the list item
                    child: GestureDetector(
                      onLongPress: isOwner
                  ? () async {
                      final confirm = await _showDeleteConfirmationDialog(expense);
                      if (confirm == true) {
                        await deleteExpense(index, expense);
                      }
                    }
                  : null,
                      child: Column(
                        children: [
                          _buildDetailedExpenseItem(
                            profileImageUrl: expense.user.profileImage,
                            title: expense.note,
                            payer: expense.user.name,
                            amount: expense.amount,
                            date: expense.createdAt,
                          ),
                          if (index < _localExpenses.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 60.0,
                                top: 12,
                                bottom: 4,
                              ),
                              child: DottedLine(dashColor: Colors.black26),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedExpenseItem({
    required String profileImageUrl,
    required String title,
    required String payer,
    required String amount,
    required String date,
  }) {
    // 1. Declare the formatter inside the method
    final currencyFormat = NumberFormat("#,##0.00", "en_US");

    // 2. Parse the String 'amount' into a double
    final double amountValue = double.tryParse(amount) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the profile image from the URL
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paid by $payer',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                // Display the date below the payer
                Text(
                  date,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          // Amount is separate on the right
          Text(
            // 3. Use the parsed double with the formatter
            '₹ ${currencyFormat.format(amountValue)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class TotalFinancialCard extends StatelessWidget {
  final Group group;

  const TotalFinancialCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    // Basic calculation for expense per person. Avoid division by zero.
    final double expensePerPerson = group.members.isNotEmpty
        ? group.totalExpenses / group.members.length
        : 0.0;
    // This should be calculated based on your app's logic
    const double paidByMe = 1000000.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
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
            // color: const Color.fromARGB(154, 76, 175, 79),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.graph_square, color: Colors.blueAccent),
                  const SizedBox(width: 5),

                  Text(
                    'Total Expenses',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              Text(
                '₹ ${currencyFormat.format(group.totalExpenses)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white30),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FinancialDetail(
                    title: 'Expense/Person',
                    amount: '₹ ${currencyFormat.format(expensePerPerson)}',
                  ),
                  _FinancialDetail(
                    title: 'Paid By Me',
                    amount: '₹ ${currencyFormat.format(paidByMe)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinancialDetail extends StatelessWidget {
  final String title;
  final String amount;

  const _FinancialDetail({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

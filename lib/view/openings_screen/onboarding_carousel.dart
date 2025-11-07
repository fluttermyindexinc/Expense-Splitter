// import 'package:expense_splitter/authenticaton_screen/login_page.dart';
// // import 'package:expense_splitter/authentication_screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Data model for each onboarding page.
// class OnboardingPageData {
//   final String imagePath;
//   final String slogan;
//   final String sentence;

//   OnboardingPageData({
//     required this.imagePath,
//     required this.slogan,
//     required this.sentence,
//   });
// }

// class OnboardingCarousel extends StatefulWidget {
//   const OnboardingCarousel({super.key});

//   @override
//   State<OnboardingCarousel> createState() => _OnboardingCarouselState();
// }

// class _OnboardingCarouselState extends State<OnboardingCarousel> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   // Content for the onboarding screens.
//   final List<OnboardingPageData> _onboardingPages = [
//     OnboardingPageData(
//       imagePath: 'assets/images/01.png',
//       slogan: 'Every expense, accounted',
//       sentence: 'Now you can effortlessly track every single one of your expenses.',
//     ),
//     OnboardingPageData(
//       imagePath: 'assets/images/02.png',
//       slogan: 'Your money\'s favorite hangout.',
//       sentence: 'This is the single most convenient place to manage finances.',
//     ),
//     OnboardingPageData(
//       imagePath: 'assets/images/03.png',
//       slogan: 'Split fairly, stay friendly.',
//       sentence: 'You can now easily split any bill with friends and family.',
//     ),
//   ];

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }

//   // Navigate to the next page and mark onboarding as complete.
//   void _onGetStarted() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_completed', true);

//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.white,
//               Color.fromARGB(255, 255, 255, 255)
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   onPageChanged: _onPageChanged,
//                   itemCount: _onboardingPages.length,
//                   itemBuilder: (context, index) {
//                     final pageData = _onboardingPages[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(pageData.imagePath, height: 300),
//                           const SizedBox(height: 50),
//                           Text(
//                             pageData.slogan,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           Text(
//                             pageData.sentence,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // Page indicators and navigation
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 50.0, left: 40, right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center, // Vertically center aligns children
//                   children: [
//                     // Page indicator dots
//                     Row(
//                       children: List.generate(_onboardingPages.length, (index) {
//                         return AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           height: 8,
//                           width: _currentPage == index ? 20 : 10,
//                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                           decoration: BoxDecoration(
//                             color: _currentPage == index
//                                 ? const Color.fromARGB(255, 33, 100, 243)
//                                 : const Color.fromARGB(255, 86, 126, 212),

//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         );
//                       }),
//                     ),

//                     // This SizedBox ensures that the height is consistent for both the button and the text.
//                     SizedBox(
                    
//                       height: 48.0, // A fixed height that works for both widgets
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: _currentPage == _onboardingPages.length - 1
//                             ? ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color.fromARGB(255, 33, 100, 243),
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 onPressed: _onGetStarted,
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text('Get Started',style: TextStyle(color: Colors.white),),
//                                     SizedBox(width: 8),
//                                     Icon(Icons.arrow_forward, size: 18,color: Colors.white,),
//                                   ],
//                                 ),
//                               )
//                             : const Row(
//                                 children: [
//                                   Text(
//                                     'Swipe right',
//                                     style: TextStyle(color: Colors.white70),
//                                   ),
//                                   SizedBox(width: 4),
//                                   // Icon(Icons.arrow_forward, color: Colors.white70, size: 18),
//                                 ],
//                               ),
//                       ),
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

import 'package:expense_splitter/authenticaton_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data model for each onboarding page.
class OnboardingPageData {
  final String imagePath;
  final String slogan;
  final String sentence;

  OnboardingPageData({
    required this.imagePath,
    required this.slogan,
    required this.sentence,
  });
}

// A reusable widget for the content of each onboarding page.
class _OnboardingPageContent extends StatelessWidget {
  final OnboardingPageData pageData;

  const _OnboardingPageContent({required this.pageData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(pageData.imagePath, height: 300),
          const SizedBox(height: 50),
          Text(
            pageData.slogan,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1E57), // A darker, more impactful color
            ),
          ),
          const SizedBox(height: 15),
          Text(
            pageData.sentence,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Content for the onboarding screens.
  final List<OnboardingPageData> _onboardingPages = [
    OnboardingPageData(
      imagePath: 'assets/images/01.png',
      slogan: 'Every Expense, Accounted For',
      sentence: 'Effortlessly track every single one of your expenses.',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/02.png',
      slogan: 'Your Money\'s Favorite Hangout',
      sentence: 'The single most convenient place to manage your finances.',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/03.png',
      slogan: 'Split Fairly, Stay Friendly',
      sentence: 'Easily split any bill with friends and family, hassle-free.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  // Function to complete onboarding and navigate to the login screen.
  // Can be called from "Get Started" or "Skip".
  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  // Navigate to the next page in the carousel.
  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // A more visually appealing gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[100]!, // Subtle gradient to light grey
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),

              // PageView for onboarding content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingPages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPageContent(pageData: _onboardingPages[index]);
                  },
                ),
              ),

              // Page indicators and navigation controls
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicator dots
                    Row(
                      children: List.generate(_onboardingPages.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 10,
                          width: _currentPage == index ? 24 : 10,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF1A1E57)
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    ),

                    // Next / Get Started Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1E57),
                        foregroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: _currentPage == _onboardingPages.length - 1
                          ? _completeOnboarding // Last page action
                          : _nextPage, // All other pages action
                      child: _currentPage == _onboardingPages.length - 1
                          ? const Icon(Icons.check) // Show checkmark on last page
                          : const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

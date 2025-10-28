import 'package:expense_splitter/Dummy/login_page.dart';
// import 'package:expense_splitter/authentication_screens/login_screen.dart';
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
      slogan: 'Every expense, accounted',
      sentence: 'Now you can effortlessly track every single one of your expenses.',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/02.png',
      slogan: 'Your money\'s favorite hangout.',
      sentence: 'This is the single most convenient place to manage finances.',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/03.png',
      slogan: 'Split fairly, stay friendly.',
      sentence: 'You can now easily split any bill with friends and family.',
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

  // Navigate to the next page and mark onboarding as complete.
  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromARGB(255, 255, 255, 255)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingPages.length,
                  itemBuilder: (context, index) {
                    final pageData = _onboardingPages[index];
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
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
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            pageData.sentence,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Page indicators and navigation
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0, left: 40, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center, // Vertically center aligns children
                  children: [
                    // Page indicator dots
                    Row(
                      children: List.generate(_onboardingPages.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 8,
                          width: _currentPage == index ? 20 : 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color.fromARGB(255, 33, 100, 243)
                                : const Color.fromARGB(255, 86, 126, 212),

                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    ),

                    // This SizedBox ensures that the height is consistent for both the button and the text.
                    SizedBox(
                    
                      height: 48.0, // A fixed height that works for both widgets
                      child: Align(
                        alignment: Alignment.center,
                        child: _currentPage == _onboardingPages.length - 1
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 33, 100, 243),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _onGetStarted,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Get Started',style: TextStyle(color: Colors.white),),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 18,color: Colors.white,),
                                  ],
                                ),
                              )
                            : const Row(
                                children: [
                                  Text(
                                    'Swipe right',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(width: 4),
                                  // Icon(Icons.arrow_forward, color: Colors.white70, size: 18),
                                ],
                              ),
                      ),
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

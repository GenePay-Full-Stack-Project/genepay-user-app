import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import 'auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingData {
  final String image;
  final String title;
  final String titleHighlight;
  final String description;
  final String descriptionHighlight;
  final Color titleColor;
  final Color highlightColor;

  OnboardingData({
    required this.image,
    required this.title,
    required this.titleHighlight,
    required this.description,
    required this.descriptionHighlight,
    required this.titleColor,
    required this.highlightColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/welcome 1.png',
      title: 'Welcome to ',
      titleHighlight: 'GenePay',
      description: 'Pay with just your face\nfast, simple, secure.',
      descriptionHighlight: 'fast, simple, secure.',
      titleColor: Color(0xFF1E3A8A),
      highlightColor: Color(0xFFFF4C3A),
    ),
    OnboardingData(
      image: 'assets/safe and secure 1.png',
      title: 'Safe and ',
      titleHighlight: 'Secure',
      description: 'Your face data is encrypted\nand never shared.',
      descriptionHighlight: 'encrypted',
      titleColor: Color(0xFF1E3A8A),
      highlightColor: Color(0xFFFF4C3A),
    ),
    OnboardingData(
      image: 'assets/areuready 1.png',
      title: 'Ready to ',
      titleHighlight: 'Pay?',
      description: 'Set up your face now and\nstart making payments.',
      descriptionHighlight: 'Set up',
      titleColor: Color(0xFF1E3A8A),
      highlightColor: Color(0xFFFF4C3A),
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

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to auth screen
      () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seen_onboarding', true);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _currentPage == index ? 32 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFFFF4C3A)
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4C3A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Ready!'
                                : 'Continue',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_currentPage < _pages.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.arrow_forward, size: 20),
                            ),
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
    );
  }
}


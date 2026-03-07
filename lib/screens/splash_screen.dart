import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Face icon and image
              Image.asset(
                'assets/png-removebg-preview 1.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40),
              // FacePay title with two colors
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Face',
                      style: TextStyle(
                        color: Color(0xFF1E3A8A), // Dark blue
                      ),
                    ),
                    TextSpan(
                      text: 'Pay',
                      style: TextStyle(
                        color: Color(0xFFFF4C3A), // Orange/Red
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                'Your face is your wallet',
                style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4C3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

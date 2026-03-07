import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';
import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/service_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceManager().initialize();

  // Determine if onboarding should be shown (only show on first run)
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(MyApp(showOnboarding: !seenOnboarding));
}

class MyApp extends StatefulWidget {
  final bool showOnboarding;

  const MyApp({super.key, this.showOnboarding = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.showOnboarding;
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isAuthenticated = await ServiceManager().authService
        .isAuthenticated();
    setState(() {
      _isAuthenticated = isAuthenticated;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    // If onboarding should be shown, present it first.
    if (_showOnboarding) {
      return MaterialApp(
        title: 'FacePay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const OnboardingScreen(),
      );
    }

    return MaterialApp(
      title: 'FacePay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: _isAuthenticated ? const MainNavigation() : const AuthScreen(),
    );
  }
}

import 'package:EliteReurbLap/core/services/storage/token_service.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  void _checkAuthAndNavigate() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final tokenService = ref.read(tokenServiceProvider);
      final token = tokenService.getToken();

      // No token saved — user needs to log in
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/splash2');
        return;
      }

      // Token exists — validate it by fetching the user profile
      final authViewModel = ref.read(authViewModelProvider.notifier);
      await authViewModel.getProfile();

      if (!mounted) return;

      final authState = ref.read(authViewModelProvider);
      if (authState.status == AuthStatus.profileLoaded) {
        // Token is valid — navigate to home
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Token is invalid/expired — clear session and show onboarding
        final sessionService = ref.read(userSessionServiceProvider);
        await sessionService.clearSession();
        await tokenService.removeToken();
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/splash2');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                // App name
                const Text(
                  'Elite Refurb Lap',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Tagline
                const Text(
                  'Refurbished Laptops, Premium Quality',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

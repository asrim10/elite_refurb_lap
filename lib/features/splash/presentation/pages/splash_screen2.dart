import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen2 extends ConsumerStatefulWidget {
  const SplashScreen2({super.key});

  @override
  ConsumerState<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends ConsumerState<SplashScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  void _checkAuthAndNavigate() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      final sessionService = ref.read(userSessionServiceProvider);
      if (sessionService.isLoggedIn()) {
        Navigator.of(context).pushReplacementNamed('/home');
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Laptop devices grid display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildDeviceGrid(),
                  ),
                  const SizedBox(height: 50),
                  // Title
                  Text(
                    'Find Perfect',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Refurbished Laptops',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Get the opportunity to own a verified refurbished laptop at an affordable price → pick-up ready.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Explore Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'EXPLORE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceGrid() {
    return SizedBox(
      height: 220,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(6, (index) {
          return _buildDevicePlaceholder(index);
        }),
      ),
    );
  }

  Widget _buildDevicePlaceholder(int index) {
    final colors = [
      Colors.blue.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
      Colors.orange.shade300,
      Colors.cyan.shade300,
      Colors.grey.shade400,
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors[index].withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.laptop_chromebook,
          color: Colors.white.withOpacity(0.8),
          size: 40,
        ),
      ),
    );
  }
}

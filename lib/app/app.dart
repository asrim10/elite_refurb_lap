import 'package:EliteReurbLap/app/theme/theme_data.dart';
import 'package:EliteReurbLap/features/auth/presentation/pages/login_screen.dart';
import 'package:EliteReurbLap/features/splash/presentation/pages/splash_screen.dart';
import 'package:EliteReurbLap/features/splash/presentation/pages/splash_screen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Myapp extends ConsumerWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Elite Refurb Lap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/splash2': (context) => const SplashScreen2(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

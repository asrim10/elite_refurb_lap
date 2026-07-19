import 'package:EliteReurbLap/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:EliteReurbLap/features/home/presentation/pages/home_screen.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';
import 'package:EliteReurbLap/features/profile/presentation/pages/profile_screen.dart';
import 'package:EliteReurbLap/features/search/presentation/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    SizedBox.shrink(), // Post — handled via push
    ChatListScreen(),
    ProfileScreen(),
  ];

  void _onTabChanged(int index) {
    // Post tab — push AddLaptopScreen instead of switching to it
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddLaptopScreen()),
      );
      return;
    }

    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}

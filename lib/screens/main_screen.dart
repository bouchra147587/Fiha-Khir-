import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_problem_screen.dart';
import 'organizations_screen.dart';
import 'profile_screen.dart';
import 'problems_screen.dart';
import 'custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
     HomePage(),
     ProblemsScreen(),
    const OrganizationsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProblemScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onAddPressed: _onAddPressed, // ✅ connect add button here
      ),
    );
  }
}

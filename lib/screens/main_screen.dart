import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_problem_screen.dart';
import 'organizations_screen.dart';
import 'profile_screen.dart';
import 'problems_screen.dart';
import 'custom_bottom_nav.dart';
import '../models/user_model.dart';

class MainScreen extends StatefulWidget {
  final User user; // pass the logged-in user

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

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
    final List<Widget> pages = [
      HomePage(user: widget.user),
      ProblemsScreen(),
      const OrganizationsScreen(),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onAddPressed: _onAddPressed,
      ),
    );
  }
}

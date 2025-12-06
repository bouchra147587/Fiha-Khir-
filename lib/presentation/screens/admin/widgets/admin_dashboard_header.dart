import 'package:flutter/material.dart';
import '../../../themes/constants.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Container(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          alignment: Alignment.bottomLeft,
          child: Text(
            'Manage and monitor platform activity',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
          ),
        ),
      ),
    );
  }
}


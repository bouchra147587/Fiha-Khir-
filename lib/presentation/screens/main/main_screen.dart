import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/navigation/navigation_cubit.dart';
import '../../../logic/cubits/navigation/navigation_state.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'home/home_screen.dart';
import '../problem/problems_screen.dart';
import '../organization/organizations_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/admin_profile_screen.dart';
import '../problem/add_problem_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<AuthCubit, dynamic>(
        builder: (context, authState) {
          final authCubit = context.read<AuthCubit>();
          final currentUser = authCubit.getCurrentUser();
          final isAdmin = currentUser?.type == UserType.admin;

          return BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              // For admin: 5 pages (Home, Problems, placeholder, Admin Dashboard, Admin Profile)
              // Center button (Add Problem) navigates separately
              // For others: 4 pages (Home, Problems, Organizations, Profile)
              final List<Widget> _pages = isAdmin
                  ? [
                      const HomeScreen(),
                      const ProblemsScreen(),
                      const SizedBox.shrink(), 
                      const AdminDashboardScreen(),
                      const AdminProfileScreen(),
                    ]
                  : [
                      const HomeScreen(),
                      const ProblemsScreen(),
                      const OrganizationsScreen(),
                      const ProfileScreen(),
                    ];

              return Scaffold(
                body: _pages[state.selectedIndex],
                bottomNavigationBar: CustomBottomNav(
                  selectedIndex: state.selectedIndex,
                  isAdmin: isAdmin,
                  onItemTapped: (index) {
                    context.read<NavigationCubit>().changeIndex(index);
                  },
                  onAddPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddProblemScreen()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}



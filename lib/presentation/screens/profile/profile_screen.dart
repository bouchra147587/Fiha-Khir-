import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';  
import '../../../logic/cubits/auth/auth_state.dart';  
import '../../../logic/cubits/locale/locale_cubit.dart';
import '../../../data/models/user_model.dart';
import '../../themes/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<AuthCubit, AuthState>(  // Change from UserCubit to AuthCubit
      builder: (context, state) {
        // Handle different auth states
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthUnauthenticated) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please login to view profile'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(l10n.login),
                  ),
                ],
              ),
            ),
          );
        }

        final user = (state as AuthAuthenticated).user;
        final isOrganization = user.type == UserType.organization;

        print('ProfileScreen - User: ${user.name}');
        print('ProfileScreen - Type: ${user.type}');
        print('ProfileScreen - Is organization: $isOrganization');
        print('ProfileScreen - Organization fields: description=${user.organizationDescription}, members=${user.organizationMembers}, verified=${user.isVerified}');

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(l10n, isOrganization),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: isOrganization ? Color(0xFFE8F5E9) : AppColors.lightGreen,
                              child: Text(
                                user.name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              isOrganization ? 'Organization' : 'Active Citizen',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.edit, color: isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen),
                              label: Text(
                                l10n.editProfile,
                                style: TextStyle(
                                  color: isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Organization Verification Badge (only for organizations)
                      if (isOrganization) ...[
                        if (user.isVerified == true)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.verified, color: Colors.green[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Verified Organization',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pending, color: Colors.orange[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Pending Verification',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            icon: Icons.report_problem_outlined,
                            label: l10n.problemsReported,
                            value: '${user.problemsReported}',
                            color: AppColors.yellowCard,
                          ),
                          _buildStatCard(
                            icon: Icons.check_circle_outline,
                            label: l10n.problemsSolved,
                            value: '${user.problemsSolved}',
                            color: AppColors.yellowCard,
                          ),
                          // Show team members for organizations
                          if (isOrganization && user.organizationMembers != null && user.organizationMembers! > 0)
                            _buildStatCard(
                              icon: Icons.group,
                              label: 'Team Members',
                              value: '${user.organizationMembers}',
                              color: Color(0xFFE3F2FD),
                            ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Account info
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Account Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildInfoCard(Icons.email_outlined, l10n.email, user.email),
                      _buildInfoCard(Icons.person_outlined, 'Username', user.username),
                      _buildInfoCard(Icons.location_on_outlined, l10n.location, user.location),
                      _buildInfoCard(Icons.calendar_month_outlined, l10n.memberSince, _formatDate(user.memberSince) ?? 'Recently'),
                      
                      // Organization specific fields
                      if (isOrganization) ...[
                        if (user.organizationDescription?.isNotEmpty == true)
                          _buildInfoCard(
                            Icons.description_outlined,
                            'Description',
                            user.organizationDescription!,
                          ),
                        if (user.organizationMembers != null)
                          _buildInfoCard(
                            Icons.group_outlined,
                            'Team Size',
                            '${user.organizationMembers} members',
                          ),
                        _buildInfoCard(
                          Icons.verified_user_outlined,
                          'Verification Status',
                          user.isVerified == true ? 'Verified' : 'Pending',
                          isVerified: user.isVerified == true,
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Language Selection
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Language",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildLanguageSelector(context),

                      const SizedBox(height: 20),

                      // Achievement / Organization Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isOrganization ? Color(0xFFE8F5E9) : AppColors.yellowCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isOrganization ? Color(0xFF0F4D37).withOpacity(0.3) : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isOrganization ? Color(0xFF0F4D37).withOpacity(0.1) : AppColors.lightGreen,
                              radius: 20,
                              child: Icon(
                                isOrganization ? Icons.business : Icons.star,
                                color: isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isOrganization 
                                      ? (user.isVerified == true ? 'Verified Organization' : 'Organization Member')
                                      : l10n.communityHero,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    isOrganization
                                      ? 'Contributing to community development'
                                      : l10n.reported25Plus,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Areas of Expertise (for organizations)
                      if (isOrganization) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color(0xFF0F4D37).withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.engineering, color: Color(0xFF0F4D37)),
                                  SizedBox(width: 8),
                                  Text(
                                    "Areas of Expertise",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Chip(
                                    label: const Text("Infrastructure"),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Color(0xFF0F4D37).withOpacity(0.3)),
                                    ),
                                  ),
                                  Chip(
                                    label: const Text("Public Works"),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Color(0xFF0F4D37).withOpacity(0.3)),
                                    ),
                                  ),
                                  Chip(
                                    label: const Text("Urban Planning"),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Color(0xFF0F4D37).withOpacity(0.3)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),

                      // Organization Action Buttons
                      if (isOrganization) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.settings, color: Color(0xFF0F4D37)),
                                label: const Text(
                                  "Settings",
                                  style: TextStyle(
                                    color: Color(0xFF0F4D37),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF0F4D37)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.group_add, color: Colors.white),
                                label: const Text(
                                  "Add Member",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0F4D37),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Logout
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: Text(
                            l10n.logout,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(AppLocalizations l10n, bool isOrganization) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          l10n.profile,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen,
                (isOrganization ? Color(0xFF0F4D37) : AppColors.primaryGreen).withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black87, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, {bool isVerified = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: isVerified ? Color(0xFF0F4D37) : Colors.black54),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isVerified ? Color(0xFF0F4D37) : Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final currentLangCode = localeCubit.getCurrentLanguageCode();
    
    // Language codes: 0=en, 1=ar, 2=fr
    final languages = [
      {'code': 0, 'name': 'English', 'flag': '🇬🇧'},
      {'code': 1, 'name': 'العربية', 'flag': '🇸🇦'},
      {'code': 2, 'name': 'Français', 'flag': '🇫🇷'},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: languages.map((lang) {
          final isSelected = lang['code'] == currentLangCode;
          return InkWell(
            onTap: () {
              localeCubit.changeLocaleByCode(lang['code'] as int);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    lang['flag'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lang['name'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primaryGreen : Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String? _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
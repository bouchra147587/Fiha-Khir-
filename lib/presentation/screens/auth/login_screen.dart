import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/organization_request_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/organization_request_repository.dart';
import '../../themes/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool isOrganizationSignup = false;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final contactPersonCtrl = TextEditingController();
  final membersCtrl = TextEditingController();
  
  final UserRepository _userRepository = UserRepository();
  final OrganizationRequestRepository _orgRequestRepository = OrganizationRequestRepository();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    usernameCtrl.dispose();
    locationCtrl.dispose();
    descriptionCtrl.dispose();
    contactPersonCtrl.dispose();
    membersCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // All users (including admin) go to MainScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primaryGreen,
                  child: const Icon(Icons.volunteer_activism,
                      color: Colors.white, size: 40),
                ),
                const SizedBox(height: 15),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(l10n.joinCommunityPlatform,
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 35),

                // Tabs
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(l10n.login,
                                style: const TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(l10n.signUp,
                                style: const TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // User type selector for signup
                if (!isLogin)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isOrganizationSignup = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isOrganizationSignup ? AppColors.primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Citizen',
                                style: TextStyle(
                                  color: !isOrganizationSignup ? Colors.white : Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isOrganizationSignup = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isOrganizationSignup ? AppColors.primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Organization',
                                style: TextStyle(
                                  color: isOrganizationSignup ? Colors.white : Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (!isLogin) const SizedBox(height: 15),

                // Name field for signup
                if (!isLogin)
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: isOrganizationSignup ? "Organization Name *" : "Full Name *",
                      hintText: isOrganizationSignup ? "e.g., City Works Association" : "e.g., John Doe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                if (!isLogin) const SizedBox(height: 15),

                // Username field for signup
                if (!isLogin)
                  TextField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      labelText: "Username *",
                      hintText: "Choose a username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                if (!isLogin) const SizedBox(height: 15),

                // Email
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: "your@email.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: "********",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // Additional fields for organization signup
                if (!isLogin && isOrganizationSignup) ...[
                  const SizedBox(height: 15),
                  TextField(
                    controller: locationCtrl,
                    decoration: InputDecoration(
                      labelText: "Location *",
                      hintText: "e.g., City Center",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: contactPersonCtrl,
                    decoration: InputDecoration(
                      labelText: "Contact Person *",
                      hintText: "e.g., John Smith",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: descriptionCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description *",
                      hintText: "Describe your organization...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: membersCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Number of Members",
                      hintText: "e.g., 25",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      if (isLogin) {
                        // Login
                        final success = await context.read<AuthCubit>().login(emailCtrl.text, passCtrl.text);
                        if (!success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid email or password')),
                          );
                        }
                      } else {
                        // Signup
                        if (isOrganizationSignup) {
                          // Organization signup - create request
                          if (nameCtrl.text.isEmpty || 
                              usernameCtrl.text.isEmpty ||
                              emailCtrl.text.isEmpty ||
                              passCtrl.text.isEmpty ||
                              locationCtrl.text.isEmpty ||
                              contactPersonCtrl.text.isEmpty ||
                              descriptionCtrl.text.isEmpty) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all required fields')),
                              );
                            }
                            return;
                          }

                          try {
                            final request = OrganizationRequest(
                              name: nameCtrl.text,
                              description: descriptionCtrl.text,
                              email: emailCtrl.text,
                              contactPerson: contactPersonCtrl.text,
                              status: OrganizationRequestStatus.pending,
                              requestedDate: DateTime.now().toString().split(' ')[0],
                              username: usernameCtrl.text,
                              password: passCtrl.text,
                              location: locationCtrl.text,
                              organizationDescription: descriptionCtrl.text,
                              organizationMembers: int.tryParse(membersCtrl.text),
                            );

                            await _orgRequestRepository.addRequest(request);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Organization signup request submitted! Waiting for admin approval.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Clear form
                              nameCtrl.clear();
                              usernameCtrl.clear();
                              emailCtrl.clear();
                              passCtrl.clear();
                              locationCtrl.clear();
                              contactPersonCtrl.clear();
                              descriptionCtrl.clear();
                              membersCtrl.clear();
                              setState(() => isLogin = true);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        } else {
                          // Regular user signup
                          if (nameCtrl.text.isEmpty || 
                              usernameCtrl.text.isEmpty ||
                              emailCtrl.text.isEmpty ||
                              passCtrl.text.isEmpty) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all required fields')),
                              );
                            }
                            return;
                          }

                          try {
                            final user = User(
                              name: nameCtrl.text,
                              email: emailCtrl.text,
                              username: usernameCtrl.text,
                              password: passCtrl.text,
                              location: locationCtrl.text.isNotEmpty ? locationCtrl.text : 'Unknown',
                              memberSince: DateTime.now().toString().split(' ')[0],
                              type: UserType.user,
                            );

                            await _userRepository.createUser(user);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Account created successfully! Please login.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Clear form and switch to login
                              nameCtrl.clear();
                              usernameCtrl.clear();
                              emailCtrl.clear();
                              passCtrl.clear();
                              locationCtrl.clear();
                              setState(() => isLogin = true);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                      isLogin ? l10n.login : l10n.signUp,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Divider(thickness: 1, color: Colors.grey[300]),
                const SizedBox(height: 10),

                Text(l10n.quickDemoLogin,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                const SizedBox(height: 15),

                demoButton(l10n.citizen),
                const SizedBox(height: 10),
                demoButton(l10n.organization),
                const SizedBox(height: 10),
                demoButton(l10n.admin),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget demoButton(String text) {
    String email = 'demo@demo.com';
    String password = 'demo';
    
    if (text == 'Admin' || text.contains('Admin')) {
      email = 'admin@fihakhir.com';
      password = 'admin123';
    } else if (text == 'Organization' || text.contains('Organization')) {
      email = 'cityworks@email.com';
      password = 'password123';
    } else {
      email = 'john.doe@email.com';
      password = 'password123';
    }

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () async {
          final success = await context.read<AuthCubit>().login(email, password);
          if (!success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed')),
            );
          }
        },
        child: Text(text, style: const TextStyle(color: AppColors.primaryGreen, fontSize: 15)),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../database/db_helper.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color mainGreen = Color(0xFF0F4D37);
  static const Color lightGreen = Color(0xFFF4F7ED);

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await dbHelper.getUser(widget.user.email, widget.user.password);
    if (u != null) {
      setState(() {
        widget.user = u;
      });
    }
  }

  Future<void> _editProfile() async {
    final updatedUser = await showDialog<User>(
      context: context,
      builder: (_) => EditProfileDialog(user: widget.user),
    );

    if (updatedUser != null) {
      await dbHelper.insertUser(updatedUser); // Save to DB
      setState(() {
        widget.user = updatedUser; // Refresh UI
      });
    }
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: mainGreen,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    )),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Card
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
                          backgroundColor: lightGreen,
                          child: Text(
                            user.name.substring(0, 2).toUpperCase(),
                            style: const TextStyle(
                              color: mainGreen,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _editProfile,
                          icon: const Icon(Icons.edit, color: mainGreen),
                          label: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: mainGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: mainGreen),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
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
                  const SizedBox(height: 20),

                  _buildInfoCard(Icons.email_outlined, "Email", user.email),
                  _buildInfoCard(Icons.person_outline, "Username", user.name),
                  _buildInfoCard(Icons.phone, "Phone", user.phone),
                  _buildInfoCard(Icons.location_on_outlined, "Location", user.location),
                  _buildInfoCard(Icons.cake_outlined, "BirthDay",
                      user.birthDay.isNotEmpty ? user.birthDay.split('T')[0] : "Not set"),

                  const SizedBox(height: 20),

                  // Log Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 16,
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
  }
}

/// -------------------
/// Edit Profile Dialog
/// -------------------
class EditProfileDialog extends StatefulWidget {
  final User user;
  const EditProfileDialog({super.key, required this.user});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController locationCtrl;
  DateTime? birthDay;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user.name);
    phoneCtrl = TextEditingController(text: widget.user.phone);
    locationCtrl = TextEditingController(text: widget.user.location);
    if (widget.user.birthDay.isNotEmpty) {
      birthDay = DateTime.parse(widget.user.birthDay);
    }
  }

  Future<void> pickBirthDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDay ?? now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => birthDay = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 10),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone")),
            const SizedBox(height: 10),
            TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: "Location")),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickBirthDay,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: birthDay != null
                        ? "BirthDay: ${birthDay!.toLocal().toString().split(' ')[0]}"
                        : "Select BirthDay",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final updatedUser = User(
              id: widget.user.id,
              name: nameCtrl.text.trim(),
              email: widget.user.email,
              password: widget.user.password,
              phone: phoneCtrl.text.trim(),
              location: locationCtrl.text.trim(),
              birthDay: birthDay?.toIso8601String() ?? widget.user.birthDay,
            );
            Navigator.pop(context, updatedUser);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

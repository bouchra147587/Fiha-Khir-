import 'package:flutter/material.dart';
import 'auth_screen.dart';

const Color mainGreen = Color(0xFF0F4D37);

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular icon logo
              const CircleAvatar(
                radius: 50,
                backgroundColor: mainGreen,
                child: Icon(
                  Icons.volunteer_activism,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Fiha Khir",
                style: TextStyle(
                  color: mainGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Join our community platform",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 50),
              loginButton(context, "Citizen"),
              const SizedBox(height: 20),
              loginButton(context, "Organization"),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // Navigate to AuthScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          );
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

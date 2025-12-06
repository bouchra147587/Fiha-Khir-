import 'package:flutter/material.dart';

class AdminEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const AdminEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.check_circle_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}


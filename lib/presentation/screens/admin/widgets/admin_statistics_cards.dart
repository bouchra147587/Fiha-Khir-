import 'package:flutter/material.dart';

class AdminStatisticsCards extends StatelessWidget {
  final Map<String, int> statistics;

  const AdminStatisticsCards({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  icon: Icons.error_outline,
                  iconColor: Colors.red,
                  label: 'Total Problems',
                  value: statistics['totalProblems']?.toString() ?? '0',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminStatCard(
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  label: 'Solved',
                  value: statistics['solvedProblems']?.toString() ?? '0',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  icon: Icons.business,
                  iconColor: Colors.blue,
                  label: 'Organizations',
                  value: statistics['organizations']?.toString() ?? '0',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminStatCard(
                  icon: Icons.access_time,
                  iconColor: Colors.orange,
                  label: 'Pending Requests',
                  value: statistics['pendingOrgRequests']?.toString() ?? '0',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const AdminStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}


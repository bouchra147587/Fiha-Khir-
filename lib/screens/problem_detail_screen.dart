import 'package:flutter/material.dart';
import 'models.dart';

class ProblemDetailScreen extends StatelessWidget {
  final Problem problem;

  const ProblemDetailScreen({Key? key, required this.problem})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 375, maxHeight: 812),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF0F4D37),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/Images/broken_street_light.jfif',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: problem.status == ProblemStatus.solved
                                ? const Color(0xFF0F4D37)
                                : const Color(0xFFFFA000),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            problem.status == ProblemStatus.solved
                                ? "Solved"
                                : "Pending",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // --- Content ---
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            problem.title,
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Progress box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Progress',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '100%',
                                      style: TextStyle(
                                        color: Color(0xFF0F4D37),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 1.0,
                                    color: const Color(0xFF0F4D37),
                                    backgroundColor: Colors.grey,
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Description box
                          _infoBox(
                            title: 'Description',
                            content: problem.description,
                          ),

                          const SizedBox(height: 20),

                          // Location box
                          _infoBoxWithIcon(
                            title: 'Location',
                            content: problem.location,
                            icon: Icons.location_on,
                          ),

                          const SizedBox(height: 20),

                          // Reported Date box
                          _infoBoxWithIcon(
                            title: 'Reported Date',
                            content: '2025-10-15',
                            icon: Icons.calendar_today,
                          ),

                          const SizedBox(height: 20),

                          // Reported By box
                          _infoBoxWithIcon(
                            title: 'Reported By',
                            content: 'Layla Ibrahim',
                            icon: Icons.person,
                          ),

                          if (problem.status == ProblemStatus.solved &&
                              problem.handledBy != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF0F4D37,
                                ).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF0F4D37,
                                  ).withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    size: 20,
                                    color: Color(0xFF0F4D37),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Taken By: ${problem.handledBy!}",
                                      style: const TextStyle(
                                        color: Color(0xFF0F4D37),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Info Box Helper ---
  Widget _infoBox({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBoxWithIcon({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF777777)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

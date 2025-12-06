import 'package:flutter/material.dart';

const Color mainGreen = Color(0xFF0F4D37);

class HomePage extends StatelessWidget {
  final List<Category> categories = [
    Category('Plants', '', Icons.spa, Color(0xFFE6FFED)),
    Category('Infrastructure', '', Icons.construction, Color(0xFFFFF3E6)),
    Category('Cleaning', '', Icons.delete, Color(0xFFE6F9FF)),
    Category('Paints', '', Icons.brush, Color(0xFFFDEEFF)),
  ];

  final List<Problem> problems = [
    Problem(
      'Broken Street Light',
      'Street light has been out for two weeks making the area unsafe at night.',
      'Elm Street Corner',
      'In Progress',
      'assets/Images/BrokenStreetLight.png',
    ),
    Problem(
      'Garbage Accumulation',
      'Uncollected waste piling up for over a week, creating health hazards.',
      'Park Avenue',
      'Pending',
      'assets/Images/GarbageAccumulation.jpg',
    ),
    Problem(
      'Playground Equipment Broken',
      'Swing set in the public park is broken and dangerous for children.',
      'Community Park',
      'Pending',
      'assets/Images/PlaygroundEquipementBroken.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildWelcomeBanner()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 16),
              child: Text(
                'What needs help today?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategoriesScroll()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 28, bottom: 12),
              child: Text(
                'Community Impact',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ImpactCard('Solved', 1, Colors.green, Icons.check_circle),
                  ImpactCard('Active', 2, Colors.orange, Icons.access_time),
                  ImpactCard('Pending', 2, Colors.red, Icons.error),
                  ImpactCard('Total', 5, Colors.green[800]!, Icons.trending_up),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 28, bottom: 12),
              child: Text(
                'Latest Problems',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: ProblemCard(problem: problems[index]),
                );
              },
              childCount: problems.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 28, bottom: 12),
              child: Text(
                'Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _QuickActionButton(
                    icon: Icons.report_problem,
                    label: 'Report Issue',
                    onTap: () {},
                  ),
                  SizedBox(width: 12),
                  _QuickActionButton(
                    icon: Icons.group,
                    label: 'View Org',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: mainGreen,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainGreen, mainGreen.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 16),
            child: Align(
              alignment: Alignment.bottomLeft,
              
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainGreen, mainGreen.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: mainGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          SizedBox(height: 8),
          Text(
            "Let's make our community better together",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFFDE6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"Every problem solved is a step towards a better community"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.green[900],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join us in making a difference today!',
                  style: TextStyle(color: Colors.grey[800], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesScroll() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(category: categories[index]);
        },
      ),
    );
  }
}

// ------------------- Widgets -------------------

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: category.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              color: mainGreen,
              size: 32,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (category.subtitle.isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  category.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ProblemCard extends StatelessWidget {
  final Problem problem;
  const ProblemCard({required this.problem});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (problem.status == 'In Progress') {
      statusColor = const Color.fromARGB(255, 247, 196, 66);
    } else if (problem.status == 'Pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                problem.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  problem.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  problem.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        problem.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              problem.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImpactCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const ImpactCard(this.label, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainGreen, mainGreen.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: mainGreen.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- Models -------------------

class Category {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;

  Category(this.title, this.subtitle, this.icon, this.bgColor);
}

class Problem {
  final String title;
  final String description;
  final String location;
  final String status;
  final String image;

  Problem(this.title, this.description, this.location, this.status, this.image);
}
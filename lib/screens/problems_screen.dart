import 'package:flutter/material.dart';
import 'models.dart';
import 'problem_detail_screen.dart';

class ProblemsScreen extends StatelessWidget {
  final List<Problem> problems = [
    Problem(
      title: "Broken Street Light",
      description: "Street light has been out for two weeks making the area unsafe at night.",
      location: "Eim Street Corner",
      date: "2025-10-23",
      status: ProblemStatus.pending,
      imagePath: "assets/Images/broken_street_light.jfif", 
    ),
    Problem(
      title: "Damaged Road on Main Street",
      description: "Large pothole causing traffic issues and potential accidents. Located near the shopping district.",
      location: "Main Street, Downtown",
      date: "2025-10-20",
      status: ProblemStatus.solved,
      handledBy: "City Works Association",
      imagePath: "assets/Images/damaged_road.jfif", 
    ),
    Problem(
      title: "Large Pathole",
      description: "Deep pothole causing vehicle damage and traffic hazards during rush hour.",
      location: "Oak Avenue & 5th Street",
      date: "2025-10-15",
      status: ProblemStatus.pending,
      imagePath: "assets/Images/pothole_road.jfif", 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Problems',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF0F4D37),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
           decoration: BoxDecoration(
            color: Color(0xFF0F4D37),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
          ),
            child: Text(
              '5 issues reported',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      Icon(Icons.search, color: Color(0xFF777777), size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search problems...",
                            hintStyle: TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_alt_outlined, size: 16, color: Color(0xFF777777)),
                          SizedBox(width: 6),
                          Text(
                            'All status',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF777777)),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Newest First',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF777777)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: problems.length,
              itemBuilder: (context, index) {
                return ProblemCard(problem: problems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProblemCard extends StatefulWidget {
  final Problem problem;

  const ProblemCard({Key? key, required this.problem}) : super(key: key);

  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProblemDetailScreen(problem: widget.problem),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 1,
              )
            ] : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: AssetImage(widget.problem.imagePath), 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.problem.status == ProblemStatus.solved 
                            ? Color(0xFF0F4D37)
                            : Color(0xFFFFA000),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.problem.status == ProblemStatus.solved ? "solved" : "pending",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.problem.title,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      widget.problem.description,
                      style: TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    
                    SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Color(0xFF777777)),
                        SizedBox(width: 4),
                        Text(
                          widget.problem.location,
                          style: TextStyle(
                            color: Color(0xFF0F4D37),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.problem.date,
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    if (widget.problem.status == ProblemStatus.solved && widget.problem.handledBy != null) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF0F4D37).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified, size: 16, color: Color(0xFF0F4D37)),
                            SizedBox(width: 8),
                            Text(
                              "Handled by: ${widget.problem.handledBy!}",
                              style: TextStyle(
                                color: Color(0xFF0F4D37),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../logic/cubits/problem/problem_cubit.dart';
import '../../../logic/cubits/problem/problem_state.dart';
import '../../../data/models/problem_model.dart';
import '../../themes/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'problem_detail_screen.dart';

class ProblemsScreen extends StatelessWidget {
  const ProblemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<ProblemCubit, ProblemState>(
      builder: (context, state) {
        if (state is ProblemLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProblemError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.allProblems),
              backgroundColor: AppColors.primaryGreen,
            ),
            body: Center(child: Text('Error: ${state.message}')),
          );
        }

        final problems = state is ProblemLoaded ? state.problems : <Problem>[];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.allProblems,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                ),
                child: Text(
                  '${problems.length} issues reported',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(16),
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
                          const SizedBox(width: 16),
                          Icon(Icons.search, color: const Color(0xFF777777), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: l10n.searchProblems,
                                hintStyle: const TextStyle(
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
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    return ProblemCard(problem: problems[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProblemCard extends StatefulWidget {
  final Problem problem;

  const ProblemCard({super.key, required this.problem});

  @override
  State<ProblemCard> createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  bool _isHovered = false;

  Widget _buildImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 50),
        ),
      );
    }

    // Check if it's an asset image or a file path
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 50),
            ),
          );
        },
      );
    } else {
      // It's a file path
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 50),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: _buildImage(widget.problem.beforePhotoPath),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.problem.status == ProblemStatus.solved 
                            ? AppColors.primaryGreen
                            : const Color(0xFFFFA000),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.problem.status == ProblemStatus.solved ? l10n.solved : l10n.pending,
                        style: const TextStyle(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.problem.title,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      widget.problem.description,
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: const Color(0xFF777777)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.problem.location,
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.problem.date,
                          style: const TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    if (widget.problem.status == ProblemStatus.solved && widget.problem.handledBy != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified, size: 16, color: AppColors.primaryGreen),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${l10n.takenBy}: ${widget.problem.handledBy!}",
                                style: const TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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


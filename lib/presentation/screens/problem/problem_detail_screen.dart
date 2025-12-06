import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../data/models/problem_model.dart';
import '../../../data/models/user_model.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../data/repositories/problem_repository.dart';
import '../../themes/constants.dart';
import '../../../l10n/app_localizations.dart';

class ProblemDetailScreen extends StatefulWidget {
  final Problem problem;

  const ProblemDetailScreen({super.key, required this.problem});

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  late Problem _currentProblem;
  final ProblemRepository _problemRepository = ProblemRepository();

  @override
  void initState() {
    super.initState();
    _currentProblem = widget.problem;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.getCurrentUser();
    final isOrganization = currentUser?.type == UserType.organization;
    final canTakeResponsibility = isOrganization && 
                                  _currentProblem.handledBy == null && 
                                  _currentProblem.isApproved &&
                                  _currentProblem.status != ProblemStatus.solved;
    final canUpdateStatus = isOrganization && 
                           _currentProblem.handledBy == currentUser?.id &&
                           _currentProblem.status != ProblemStatus.solved;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          l10n.back,
          style: const TextStyle(
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
                color: Colors.grey[300],
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: _buildDetailImage(_currentProblem.beforePhotoPath),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _currentProblem.status == ProblemStatus.solved
                        ? AppColors.primaryGreen
                        : _currentProblem.status == ProblemStatus.inProgress
                            ? Colors.blue
                            : const Color(0xFFFFA000),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _currentProblem.status == ProblemStatus.solved 
                        ? l10n.solved 
                        : _currentProblem.status == ProblemStatus.inProgress
                            ? 'In Progress'
                            : l10n.pending,
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

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentProblem.title,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.progress,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _currentProblem.status == ProblemStatus.solved 
                                  ? '100%' 
                                  : _currentProblem.status == ProblemStatus.inProgress
                                      ? '75%'
                                      : '50%',
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
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
                            value: _currentProblem.status == ProblemStatus.solved 
                                ? 1.0 
                                : _currentProblem.status == ProblemStatus.inProgress
                                    ? 0.75
                                    : 0.5,
                            color: AppColors.primaryGreen,
                            backgroundColor: Colors.grey,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _infoBox(title: l10n.description, content: _currentProblem.description),
                  const SizedBox(height: 20),
                  _infoBoxWithIcon(title: l10n.location, content: _currentProblem.location, icon: Icons.location_on),
                  const SizedBox(height: 20),
                  _infoBoxWithIcon(title: l10n.reportedDate, content: _currentProblem.date, icon: Icons.calendar_today),
                  if (_currentProblem.reportedBy != null) ...[
                    const SizedBox(height: 20),
                    _infoBoxWithIcon(title: l10n.reportedBy, content: _currentProblem.reportedBy!, icon: Icons.person),
                  ],

                  if (_currentProblem.handledBy != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, size: 20, color: AppColors.primaryGreen),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${l10n.takenBy}: ${_currentProblem.handledBy!}",
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // After photo if solved
                  if (_currentProblem.status == ProblemStatus.solved && _currentProblem.afterPhotoPath != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      'After Photo',
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildAfterImage(_currentProblem.afterPhotoPath),
                    ),
                  ],

                  // Action buttons for organizations
                  if (canTakeResponsibility || canUpdateStatus) ...[
                    const SizedBox(height: 30),
                    if (canTakeResponsibility)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.handshake, color: Colors.white),
                          label: const Text(
                            'Take Responsibility',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () => _takeResponsibility(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    if (canUpdateStatus) ...[
                      if (canTakeResponsibility) const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                          label: const Text(
                            'Mark as Solved',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () => _markAsSolved(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.update, color: AppColors.primaryGreen),
                          label: const Text(
                            'Update Status',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () => _updateStatus(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryGreen,
                            side: const BorderSide(color: AppColors.primaryGreen),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 80),
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
              child: Icon(Icons.image, color: Colors.grey, size: 80),
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
              child: Icon(Icons.image, color: Colors.grey, size: 80),
            ),
          );
        },
      );
    }
  }

  Widget _buildAfterImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        color: Colors.grey[300],
        width: double.infinity,
        height: 200,
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 60),
        ),
      );
    }

    // Check if it's an asset image or a file path
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: 200,
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 60),
            ),
          );
        },
      );
    } else {
      // It's a file path
      return Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: 200,
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 60),
            ),
          );
        },
      );
    }
  }

  Future<void> _takeResponsibility() async {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.getCurrentUser();
    if (currentUser == null || _currentProblem.id == null) return;

    try {
      await _problemRepository.updateProblemStatus(
        _currentProblem.id!,
        ProblemStatus.inProgress,
        handledBy: currentUser.id,
      );
      
      setState(() {
        _currentProblem = _currentProblem.copyWith(
          status: ProblemStatus.inProgress,
          handledBy: currentUser.id,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have taken responsibility for this problem'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _markAsSolved() async {
    if (_currentProblem.id == null) return;

    try {
      // For now, use the same photo path as before photo
      // In a real app, you would upload a new photo here
      await _problemRepository.updateProblemStatus(
        _currentProblem.id!,
        ProblemStatus.solved,
        afterPhotoPath: _currentProblem.beforePhotoPath, // TODO: Implement photo upload
      );
      
      setState(() {
        _currentProblem = _currentProblem.copyWith(
          status: ProblemStatus.solved,
          afterPhotoPath: _currentProblem.beforePhotoPath,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Problem marked as solved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _updateStatus() async {
    if (_currentProblem.id == null) return;

    final newStatus = await showDialog<ProblemStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('In Progress'),
              leading: Radio<ProblemStatus>(
                value: ProblemStatus.inProgress,
                groupValue: _currentProblem.status,
                onChanged: (value) => Navigator.pop(context, value),
              ),
            ),
            ListTile(
              title: const Text('Solved'),
              leading: Radio<ProblemStatus>(
                value: ProblemStatus.solved,
                groupValue: _currentProblem.status,
                onChanged: (value) => Navigator.pop(context, value),
              ),
            ),
          ],
        ),
      ),
    );

    if (newStatus != null && newStatus != _currentProblem.status) {
      try {
        await _problemRepository.updateProblemStatus(
          _currentProblem.id!,
          newStatus,
        );
        
        setState(() {
          _currentProblem = _currentProblem.copyWith(status: newStatus);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Status updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
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


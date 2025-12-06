import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/problem_model.dart';
import '../../../data/models/organization_request_model.dart';
import 'admin_dashboard_controller.dart';
import 'widgets/admin_dashboard_header.dart';
import 'widgets/admin_statistics_cards.dart';
import 'widgets/admin_tabs_section.dart';
import 'widgets/admin_problem_request_card.dart';
import 'widgets/admin_org_request_card.dart';
import 'widgets/admin_empty_state.dart';
import '../../../logic/cubits/problem/problem_cubit.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminDashboardController _controller = AdminDashboardController();
  
  Map<String, int> _statistics = {};
  List<Problem> _pendingProblems = [];
  List<OrganizationRequest> _pendingOrgRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _controller.getStatistics();
      final problems = await _controller.getPendingProblems();
      final orgRequests = await _controller.getPendingOrgRequests();
      
      setState(() {
        _statistics = stats;
        _pendingProblems = problems;
        _pendingOrgRequests = orgRequests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                const AdminDashboardHeader(),
                SliverToBoxAdapter(
                  child: AdminStatisticsCards(statistics: _statistics),
                ),
                SliverToBoxAdapter(
                  child: AdminTabsSection(
                    tabController: _tabController,
                    pendingProblemsCount: _pendingProblems.length,
                    pendingOrgRequestsCount: _pendingOrgRequests.length,
                  ),
                ),
                SliverFillRemaining(
                  child: _buildTabContent(),
                ),
              ],
            ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildProblemRequestsTab(),
        _buildOrgRequestsTab(),
      ],
    );
  }

  Widget _buildProblemRequestsTab() {
    if (_pendingProblems.isEmpty) {
      return const AdminEmptyState(
        message: 'No pending problem requests',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingProblems.length,
      itemBuilder: (context, index) {
        final problem = _pendingProblems[index];
        return AdminProblemRequestCard(
          problem: problem,
          onApprove: () => _approveProblem(problem.id!),
          onReject: () => _rejectProblem(problem.id!),
        );
      },
    );
  }

  Widget _buildOrgRequestsTab() {
    if (_pendingOrgRequests.isEmpty) {
      return const AdminEmptyState(
        message: 'No pending organization requests',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingOrgRequests.length,
      itemBuilder: (context, index) {
        final request = _pendingOrgRequests[index];
        return AdminOrgRequestCard(
          request: request,
          onApprove: () => _approveOrgRequest(request.id!),
          onReject: () => _rejectOrgRequest(request.id!),
        );
      },
    );
  }

  Future<void> _approveProblem(String problemId) async {
    try {
      await _controller.approveProblem(problemId);
      // Refresh admin panel data
      await _loadData();
      // Notify problems cubit so main problems list updates immediately
      try {
        context.read<ProblemCubit>().refreshProblems();
      } catch (_) {}
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Problem approved successfully')),
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

  Future<void> _rejectProblem(String problemId) async {
    final reasonController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Problem'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Rejection Reason',
            hintText: 'Enter reason for rejection...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        await _controller.rejectProblem(problemId, reasonController.text);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Problem rejected')),
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

  Future<void> _approveOrgRequest(String requestId) async {
    try {
      await _controller.approveOrgRequest(requestId);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization request approved')),
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

  Future<void> _rejectOrgRequest(String requestId) async {
    final reasonController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Organization Request'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Rejection Reason',
            hintText: 'Enter reason for rejection...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        await _controller.rejectOrgRequest(requestId, reasonController.text);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Organization request rejected')),
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
}

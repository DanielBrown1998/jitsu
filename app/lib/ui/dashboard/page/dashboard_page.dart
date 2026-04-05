import 'package:flutter/material.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/state.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:app/ui/dashboard/logic/command.dart';
import 'package:app/ui/dashboard/logic/vm.dart';
import 'package:app/ui/dashboard/page/components/dashboard_header.dart';
import 'package:app/ui/dashboard/page/components/classes_section.dart';
import 'package:app/ui/dashboard/page/components/quick_actions_row.dart';
import 'package:app/ui/dashboard/page/components/stats_grid.dart';
import 'package:app/ui/route.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _lastLoadKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDashboardIfNeeded();
  }

  void _loadDashboardIfNeeded() {
    final authVm = context.read<AuthVm>();
    final dashboardVm = context.read<DashboardVm>();

    if (!authVm.state.isLoggedIn) return;

    final role = authVm.state.role;
    if (role != UserRole.admin && role != UserRole.professor) {
      return;
    }

    final professor = authVm.state.professor;
    final key =
        '${role.name}:${professor?.id ?? ''}:${professor?.turmasIds.join(',') ?? ''}';
    if (key == _lastLoadKey) {
      return;
    }

    _lastLoadKey = key;
    dashboardVm.loadDashboardCommand.execute(
      input: LoadDashboardInput(
        role: role,
        professorId: professor?.id,
        professorName: professor?.nome,
        turmaIds: role == UserRole.professor ? professor?.turmasIds : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(onLogout: () => _handleLogout(context)),
                  const SizedBox(height: 24),
                  StatsGrid(
                    totalTurmas: vm.state.totalTurmasAtivas,
                    aulasHoje: vm.state.aulasHoje,
                  ),
                  if (vm.state.isLoading) ...[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(minHeight: 2),
                  ],
                  if (vm.state.error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      vm.state.error!,
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  QuickActionsRow(
                    onAttendanceTap: () =>
                        context.go(AttendanceSelectRoute.path),
                    onNewStudentTap: () => context.go(StudentsNewRoute.path),
                    onGraduationTap: () => context.go(GraduationListRoute.path),
                    onReportsTap: () => context.go(ReportsRoute.path),
                  ),
                  const SizedBox(height: 24),
                  ClassesSection(
                    onSeeAllTap: () => context.go(StudentsListRoute.path),
                    classes: vm.state.classes,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final vm = context.read<AuthVm>();
    await vm.logoutCommand.execute(input: LogoutInput());

    if (!context.mounted) return;
    final error = vm.state.error;
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

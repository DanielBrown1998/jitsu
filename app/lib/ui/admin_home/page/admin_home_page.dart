import 'package:flutter/material.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:app/ui/route.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AdminHeader(onLogout: () => _handleLogout(context)),
              const SizedBox(height: 24),
              const _StatsGrid(),
              const SizedBox(height: 24),
              _QuickActionsRow(
                onAttendanceTap: () => context.go(AttendanceSelectRoute.path),
                onNewStudentTap: () => context.go(StudentsNewRoute.path),
                onGraduationTap: () => context.go(GraduationListRoute.path),
                onReportsTap: () => context.go(ReportsRoute.path),
              ),
              const SizedBox(height: 24),
              _ClassesSection(
                onSeeAllTap: () => context.go(StudentsListRoute.path),
              ),
            ],
          ),
        ),
      ),
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

class _AdminHeader extends StatelessWidget {
  final VoidCallback onLogout;

  const _AdminHeader({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Color(0xFF18181B),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Visao geral da academia',
                style: TextStyle(
                  color: Color(0xFF71717A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE4E4E7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?u=admin'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Logout provisório',
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Color(0xFF3F3F46)),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: const [
        _StatCard(
          label: 'Total Alunos',
          value: '124',
          icon: Icons.groups_outlined,
          trend: '+12% este mes',
        ),
        _StatCard(label: 'Aulas Hoje', value: '4', icon: Icons.calendar_month),
        _StatCard(label: 'Elegiveis', value: '8', icon: Icons.school_outlined),
        _StatCard(
          label: 'Turmas Ativas',
          value: '12',
          icon: Icons.emoji_events_outlined,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? trend;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF71717A),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Icon(icon, size: 17, color: const Color(0xFFA1A1AA)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF18181B),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (trend != null)
            const Row(
              children: [
                Icon(Icons.trending_up, size: 12, color: Color(0xFF16A34A)),
                SizedBox(width: 2),
                Text(
                  '+12% este mes',
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final VoidCallback onAttendanceTap;
  final VoidCallback onNewStudentTap;
  final VoidCallback onGraduationTap;
  final VoidCallback onReportsTap;

  const _QuickActionsRow({
    required this.onAttendanceTap,
    required this.onNewStudentTap,
    required this.onGraduationTap,
    required this.onReportsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acesso Rapido',
          style: TextStyle(
            color: Color(0xFF18181B),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _QuickAction(
                label: 'Chamada',
                icon: Icons.check,
                backgroundColor: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF166534),
                onTap: onAttendanceTap,
              ),
              const SizedBox(width: 16),
              _QuickAction(
                label: 'Novo Aluno',
                icon: Icons.groups_outlined,
                backgroundColor: const Color(0xFFF4F4F5),
                iconColor: const Color(0xFF3F3F46),
                onTap: onNewStudentTap,
              ),
              const SizedBox(width: 16),
              _QuickAction(
                label: 'Graduar',
                icon: Icons.school_outlined,
                backgroundColor: const Color(0xFFFEF9C3),
                iconColor: const Color(0xFF854D0E),
                onTap: onGraduationTap,
              ),
              const SizedBox(width: 16),
              _QuickAction(
                label: 'Relatorios',
                icon: Icons.description_outlined,
                backgroundColor: const Color(0xFFF4F4F5),
                iconColor: const Color(0xFF3F3F46),
                onTap: onReportsTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 72,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Color(0xFF52525B),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassesSection extends StatelessWidget {
  final VoidCallback onSeeAllTap;

  const _ClassesSection({required this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    const classes = [
      _ClassItemData(
        time: '07:00',
        name: 'Jiu-Jitsu Fundamentals',
        instructorAndType: 'Mestre Rickson • Adulto',
        studentsLabel: '12 alunos',
      ),
      _ClassItemData(
        time: '12:00',
        name: 'Competition Class',
        instructorAndType: 'Prof. Galvao • Adulto',
        studentsLabel: '18 alunos',
      ),
      _ClassItemData(
        time: '18:30',
        name: 'Kids Beginner',
        instructorAndType: 'Inst. Bia • Kids',
        studentsLabel: '24 alunos',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Turmas de Hoje',
                style: TextStyle(
                  color: Color(0xFF18181B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: onSeeAllTap,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF71717A),
              ),
              child: const Text(
                'Ver todas',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in classes) ...[
          _ClassRow(item: item),
          if (item != classes.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ClassItemData {
  final String time;
  final String name;
  final String instructorAndType;
  final String studentsLabel;

  const _ClassItemData({
    required this.time,
    required this.name,
    required this.instructorAndType,
    required this.studentsLabel,
  });
}

class _ClassRow extends StatelessWidget {
  final _ClassItemData item;

  const _ClassRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF3F3F46),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Color(0xFF18181B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.instructorAndType,
                  style: const TextStyle(
                    color: Color(0xFF71717A),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.studentsLabel,
              style: const TextStyle(
                color: Color(0xFF3F3F46),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

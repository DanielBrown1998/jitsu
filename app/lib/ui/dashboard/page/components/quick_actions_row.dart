import 'package:flutter/material.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback onAttendanceTap;
  final VoidCallback onNewStudentTap;
  final VoidCallback onGraduationTap;
  final VoidCallback onReportsTap;

  const QuickActionsRow({
    super.key,
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

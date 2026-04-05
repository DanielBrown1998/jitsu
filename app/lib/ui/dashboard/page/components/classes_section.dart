import 'package:flutter/material.dart';
import 'package:app/ui/dashboard/logic/state.dart';

class ClassesSection extends StatelessWidget {
  final VoidCallback onSeeAllTap;
  final List<DashboardClassItem> classes;

  const ClassesSection({
    super.key,
    required this.onSeeAllTap,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
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
        if (classes.isEmpty)
          const Text(
            'Nenhuma turma programada para hoje.',
            style: TextStyle(
              color: Color(0xFF71717A),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        for (final item in classes) ...[
          _ClassRow(item: item),
          if (item != classes.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ClassRow extends StatelessWidget {
  final DashboardClassItem item;

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

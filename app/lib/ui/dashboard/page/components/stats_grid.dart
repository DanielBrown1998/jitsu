import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final int totalTurmas;
  final int aulasHoje;

  const StatsGrid({
    super.key,
    required this.totalTurmas,
    required this.aulasHoje,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _StatCard(
          label: 'Total Turmas',
          value: totalTurmas.toString(),
          icon: Icons.groups_outlined,
          trend: null,
        ),
        _StatCard(
          label: 'Aulas Hoje',
          value: aulasHoje.toString(),
          icon: Icons.calendar_month,
        ),
        const _StatCard(
          label: 'Elegiveis',
          value: '-',
          icon: Icons.school_outlined,
        ),
        _StatCard(
          label: 'Turmas Ativas',
          value: totalTurmas.toString(),
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

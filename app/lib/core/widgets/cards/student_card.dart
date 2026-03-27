import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String rank;
  final int progress;
  final bool active;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.name,
    required this.rank,
    required this.progress,
    this.active = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: active
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Faixa $rank • $progress aulas',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                active ? Icons.check_circle : Icons.do_not_disturb_on,
                color: active ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

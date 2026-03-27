import 'package:flutter/material.dart';
import 'package:app/core/widgets/buttons/jitsu_button.dart';

class GraduationCandidateCard extends StatelessWidget {
  final String name;
  final String currentRank;
  final String nextRank;
  final VoidCallback onPromote;

  const GraduationCandidateCard({
    super.key,
    required this.name,
    required this.currentRank,
    required this.nextRank,
    required this.onPromote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'De $currentRank para $nextRank',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: JitsuButton(
                label: 'Promover Aluno',
                variant: JitsuButtonVariant.secondary,
                onPressed: onPromote,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

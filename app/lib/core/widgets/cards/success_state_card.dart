import 'package:flutter/material.dart';
import 'package:app/core/widgets/buttons/jitsu_button.dart';

class SuccessStateCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  const SuccessStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    this.iconColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 96, color: iconColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            JitsuButton(label: buttonLabel, onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}

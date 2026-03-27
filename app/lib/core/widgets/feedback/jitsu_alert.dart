import 'package:flutter/material.dart';

enum JitsuAlertVariant { info, success, warning, error }

class JitsuAlert extends StatelessWidget {
  final String title;
  final String description;
  final JitsuAlertVariant variant;
  final Widget? trailing;

  const JitsuAlert({
    super.key,
    required this.title,
    required this.description,
    this.variant = JitsuAlertVariant.info,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final style = _styleForVariant(variant);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: style.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.foreground, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: style.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: style.foreground.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }

  _AlertStyle _styleForVariant(JitsuAlertVariant variant) {
    switch (variant) {
      case JitsuAlertVariant.success:
        return _AlertStyle(
          background: const Color(0xFFEAF8EF),
          border: const Color(0xFF9AD7AD),
          foreground: const Color(0xFF1D6A34),
          icon: Icons.check_circle_rounded,
        );
      case JitsuAlertVariant.warning:
        return _AlertStyle(
          background: const Color(0xFFFFF6E9),
          border: const Color(0xFFFFD9A1),
          foreground: const Color(0xFF8D5A00),
          icon: Icons.warning_amber_rounded,
        );
      case JitsuAlertVariant.error:
        return _AlertStyle(
          background: const Color(0xFFFCECED),
          border: const Color(0xFFF1B0B5),
          foreground: const Color(0xFF8A1C24),
          icon: Icons.error_rounded,
        );
      case JitsuAlertVariant.info:
        return _AlertStyle(
          background: const Color(0xFFEFF4FF),
          border: const Color(0xFFB4C7FF),
          foreground: const Color(0xFF1E3A8A),
          icon: Icons.info_rounded,
        );
    }
  }
}

class _AlertStyle {
  final Color background;
  final Color border;
  final Color foreground;
  final IconData icon;

  const _AlertStyle({
    required this.background,
    required this.border,
    required this.foreground,
    required this.icon,
  });
}

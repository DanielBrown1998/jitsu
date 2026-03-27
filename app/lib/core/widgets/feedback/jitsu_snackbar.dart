import 'package:flutter/material.dart';

enum JitsuSnackBarVariant { success, error, warning, info }

class JitsuSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    JitsuSnackBarVariant variant = JitsuSnackBarVariant.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final style = _variantStyle(theme, variant);
    final backgroundColor = style.backgroundColor;
    final icon = style.icon;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          action: action,
        ),
      );
  }

  static _SnackBarStyle _variantStyle(
    ThemeData theme,
    JitsuSnackBarVariant variant,
  ) {
    switch (variant) {
      case JitsuSnackBarVariant.success:
        return _SnackBarStyle(
          backgroundColor: Colors.green.shade700,
          icon: Icons.check_circle_rounded,
        );
      case JitsuSnackBarVariant.error:
        return _SnackBarStyle(
          backgroundColor: theme.colorScheme.error,
          icon: Icons.error_rounded,
        );
      case JitsuSnackBarVariant.warning:
        return _SnackBarStyle(
          backgroundColor: Colors.orange.shade800,
          icon: Icons.warning_rounded,
        );
      case JitsuSnackBarVariant.info:
        return _SnackBarStyle(
          backgroundColor: theme.colorScheme.primary,
          icon: Icons.info_rounded,
        );
    }
  }
}

class _SnackBarStyle {
  final Color backgroundColor;
  final IconData icon;

  const _SnackBarStyle({required this.backgroundColor, required this.icon});
}

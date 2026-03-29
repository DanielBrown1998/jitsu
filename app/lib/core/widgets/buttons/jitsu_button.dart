import 'package:flutter/material.dart';

enum JitsuButtonVariant { primary, secondary, outline, destructive }

class JitsuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final JitsuButtonVariant variant;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Widget? icon;

  const JitsuButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.variant = JitsuButtonVariant.primary,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    this.borderRadius = 10,
    this.icon,
  });

  Color _backgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (variant) {
      case JitsuButtonVariant.primary:
        return theme.colorScheme.primary;
      case JitsuButtonVariant.secondary:
        return theme.colorScheme.secondary;
      case JitsuButtonVariant.outline:
        return Colors.transparent;
      case JitsuButtonVariant.destructive:
        return theme.colorScheme.error;
    }
  }

  Color _foregroundColor(BuildContext context) {
    switch (variant) {
      case JitsuButtonVariant.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case JitsuButtonVariant.secondary:
        return Theme.of(context).colorScheme.onSecondary;
      case JitsuButtonVariant.outline:
        return Theme.of(context).colorScheme.primary;
      case JitsuButtonVariant.destructive:
        return Theme.of(context).colorScheme.onError;
    }
  }

  BorderSide _borderSide(BuildContext context) {
    switch (variant) {
      case JitsuButtonVariant.outline:
        return BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        );
      default:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = _foregroundColor(context);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _backgroundColor(context),
        foregroundColor: foregroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: _borderSide(context),
        ),
        elevation: variant == JitsuButtonVariant.outline ? 0 : 2,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  _foregroundColor(context),
                ),
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  IconTheme.merge(
                    data: IconThemeData(color: foregroundColor),
                    child: icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
    );
  }
}

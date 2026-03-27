import 'package:flutter/material.dart';

class JitsuForm extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const JitsuForm({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

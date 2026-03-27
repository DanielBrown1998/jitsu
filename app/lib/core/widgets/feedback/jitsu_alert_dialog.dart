import 'package:flutter/material.dart';
import 'package:app/core/widgets/buttons/jitsu_button.dart';

class JitsuAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const JitsuAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: Text(description),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: JitsuButton(
                label: cancelLabel,
                variant: JitsuButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: JitsuButton(
                label: confirmLabel,
                variant: JitsuButtonVariant.destructive,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> showJitsuAlertDialog(
  BuildContext context, {
  required String title,
  required String description,
  required VoidCallback onConfirm,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => JitsuAlertDialog(
      title: title,
      description: description,
      onConfirm: onConfirm,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}

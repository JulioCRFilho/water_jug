import 'package:flutter/material.dart';
import 'package:water_jug/design_system/text/common.dart';

class ErrorDialog extends StatelessWidget {
  final String reason;

  const ErrorDialog({
    super.key,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const CommonText('Solution not possible.'),
      content: CommonText(reason),
    );
  }

  void show(BuildContext context) => showAdaptiveDialog(
        context: context,
        builder: (context) => this,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_jug/design_system/text/common.dart';

class BucketWidget extends StatelessWidget {
  final String label;
  final TextEditingController xController;

  const BucketWidget({
    super.key,
    required this.label,
    required this.xController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                gapPadding: 8,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              counterText: '',
            ),
            inputFormatters: [
              FilteringTextInputFormatter(
                RegExp(r'\D+'),
                allow: false,
              ),
            ],
            keyboardType: TextInputType.number,
            controller: xController,
            maxLength: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(label),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_jug/design_system/paint/bucket.dart';
import 'package:water_jug/design_system/text/common.dart';

class BucketWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double proportion;

  const BucketWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.proportion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BucketPaint(
          proportion: proportion,
          child: SizedBox(
            width: 30,
            child: TextField(
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter(
                  RegExp(r'\D+'),
                  allow: false,
                ),
              ],
              decoration: const InputDecoration(
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              controller: controller,
              maxLength: 3,
            ),
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

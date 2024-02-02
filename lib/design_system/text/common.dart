import 'package:flutter/material.dart';

class CommonText extends Text {
  const CommonText(
    super.data, {
    super.key,
    super.textAlign = TextAlign.center,
    super.style = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
  });
}

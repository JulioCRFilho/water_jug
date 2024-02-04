import 'package:flutter/material.dart';

class WaterFillWidget extends StatelessWidget {
  final double proportion;

  const WaterFillWidget(this.proportion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: _WaterClipper(),
        child: Column(
          children: [
            Flexible(child: Container()),
            AnimatedContainer(
              alignment: Alignment.bottomCenter,
              height: 62 * proportion,
              color: Colors.blue[300],
              duration: const Duration(milliseconds: 600),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width * 0.34, size.height * 0.86)
      ..lineTo(size.width * 0.24, size.height * 0.34)
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.34,
        size.width * 0.76,
        size.height * 0.34,
      )
      ..lineTo(size.width * 0.66, size.height * 0.86);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

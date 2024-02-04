import 'package:flutter/material.dart';
import 'package:water_jug/design_system/clipper/water.dart';

class BucketPaint extends StatelessWidget {
  final Widget child;
  final double proportion;

  const BucketPaint({
    super.key,
    required this.child,
    required this.proportion,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BucketPainter(),
      child: SizedBox.square(
        dimension: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            WaterFillWidget(proportion),
            child,
          ],
        ),
      ),
    );
  }
}

class BucketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    ///Draws the bucket
    final bucketPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.9)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.25,
          size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.9)
      ..close();

    canvas.drawPath(bucketPath, paint);

    ///Draws the handler
    final handlePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(
          size.width * 0.5, 0, size.width * 0.8, size.height * 0.3);

    canvas.drawPath(handlePath, paint);

    ///Adds the bucket's opening
    final topRidgePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.28,
          size.width * 0.8, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.32,
          size.width * 0.2, size.height * 0.3);

    canvas.drawPath(topRidgePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

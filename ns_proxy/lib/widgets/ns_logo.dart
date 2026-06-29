import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Stylized NS monogram logo matching the brand identity.
class NsLogo extends StatelessWidget {
  const NsLogo({super.key, this.size = 120, this.showGlow = true});

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: showGlow
            ? BoxDecoration(boxShadow: AppColors.greenGlow(blur: size * 0.25))
            : null,
        child: CustomPaint(
          painter: _NsLogoPainter(),
          size: Size.square(size),
        ),
      ),
    );
  }
}

class _NsLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..shader = AppColors.logoGradient.createShader(
        Rect.fromLTWH(0, 0, w, h),
      )
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..shader = AppColors.logoGradient.createShader(
        Rect.fromLTWH(0, w * 0.1, w, h * 0.9),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    // Letter N — angular strokes
    final nPath = Path()
      ..moveTo(w * 0.12, h * 0.82)
      ..lineTo(w * 0.12, h * 0.18)
      ..lineTo(w * 0.52, h * 0.72)
      ..lineTo(w * 0.52, h * 0.18)
      ..lineTo(w * 0.72, h * 0.18)
      ..lineTo(w * 0.72, h * 0.82)
      ..lineTo(w * 0.32, h * 0.28)
      ..lineTo(w * 0.32, h * 0.82)
      ..close();

    // Letter S — flows from N diagonal
    final sPath = Path()
      ..moveTo(w * 0.58, h * 0.22)
      ..lineTo(w * 0.88, h * 0.22)
      ..lineTo(w * 0.88, h * 0.38)
      ..lineTo(w * 0.68, h * 0.38)
      ..lineTo(w * 0.68, h * 0.46)
      ..lineTo(w * 0.88, h * 0.46)
      ..lineTo(w * 0.88, h * 0.82)
      ..lineTo(w * 0.58, h * 0.82)
      ..lineTo(w * 0.58, h * 0.66)
      ..lineTo(w * 0.78, h * 0.66)
      ..lineTo(w * 0.78, h * 0.58)
      ..lineTo(w * 0.58, h * 0.58)
      ..close();

    canvas.drawPath(nPath, paint);
    canvas.drawPath(sPath, paint);

    // Highlight edges for 3D bevel effect
    canvas.drawPath(nPath, stroke..strokeWidth = w * 0.02);
    canvas.drawPath(sPath, stroke..strokeWidth = w * 0.02);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

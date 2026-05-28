import 'package:flutter/material.dart';
import 'dart:math';
import '../config/theme_config.dart';

class AnimatedRingsLogo extends StatefulWidget {
  final String text;
  const AnimatedRingsLogo({super.key, required this.text});

  @override
  State<AnimatedRingsLogo> createState() => _AnimatedRingsLogoState();
}

class _AnimatedRingsLogoState extends State<AnimatedRingsLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer solid ring
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeConfig.neonCyan.withOpacity(0.25),
                width: 1,
              ),
            ),
          ),
          // Middle dashed ring (rotating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: CustomPaint(
                  size: const Size(128, 128),
                  painter: DashedRingPainter(),
                ),
              );
            },
          ),
          // Inner solid ring with glow
          Container(
            width: 106,
            height: 106,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeConfig.neonCyan.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeConfig.neonCyan.withOpacity(0.1),
                  blurRadius: 24,
                ),
              ],
            ),
          ),
          // Center content
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeConfig.neonCyan.withOpacity(0.6),
                width: 1.5,
              ),
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.3),
                colors: [
                  ThemeConfig.neonCyan.withOpacity(0.18),
                  ThemeConfig.neonCyan.withOpacity(0.04),
                ],
                stops: const [0.0, 0.7],
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeConfig.neonCyan.withOpacity(0.35),
                  blurRadius: 32,
                ),
                BoxShadow(
                  color: ThemeConfig.neonCyan.withOpacity(0.1),
                  blurRadius: 24,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: ThemeConfig.neonCyan,
                shadows: [
                  Shadow(
                    color: ThemeConfig.neonCyan.withOpacity(0.9),
                    blurRadius: 18,
                  ),
                  Shadow(
                    color: ThemeConfig.neonCyan.withOpacity(0.4),
                    blurRadius: 36,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeConfig.neonCyan.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const int dashCount = 24;
    const double dashAngle = (2 * pi) / (dashCount * 2);

    for (int i = 0; i < dashCount * 2; i += 2) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * dashAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

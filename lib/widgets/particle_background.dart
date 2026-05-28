import 'dart:math';
import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = List.generate(40, (index) => Particle());

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: const Color(0xFF050A0E), // Deep dark navy/black
          child: CustomPaint(
            painter: ParticlePainter(_particles, _controller.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = Random().nextDouble() * 2 + 0.5;
  double vx = (Random().nextDouble() - 0.5) * 0.001;
  double vy = (Random().nextDouble() - 0.5) * 0.001;
  double opacity = Random().nextDouble() * 0.5 + 0.1;

  void move() {
    x += vx;
    y += vy;
    if (x < 0 || x > 1) vx = -vx;
    if (y < 0 || y > 1) vy = -vy;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = ThemeConfig.neonCyan;
    final linePaint = Paint()
      ..color = ThemeConfig.neonCyan.withOpacity(0.05)
      ..strokeWidth = 0.5;

    for (int i = 0; i < particles.length; i++) {
      var p1 = particles[i];
      p1.move();
      
      dotPaint.color = ThemeConfig.neonCyan.withOpacity(p1.opacity);
      canvas.drawCircle(
        Offset(p1.x * size.width, p1.y * size.height),
        p1.size,
        dotPaint,
      );

      // Draw lines between nearby particles
      for (int j = i + 1; j < particles.length; j++) {
        var p2 = particles[j];
        double dx = (p1.x - p2.x) * size.width;
        double dy = (p1.y - p2.y) * size.height;
        double distance = sqrt(dx * dx + dy * dy);

        if (distance < 150) {
          linePaint.color = ThemeConfig.neonCyan.withOpacity(0.1 * (1 - distance / 150));
          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

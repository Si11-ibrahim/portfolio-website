import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double dx;
  double dy;
  double radius;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
    required this.color,
  });
}

class ParticleBackground extends StatefulWidget {
  final Color baseColor;
  const ParticleBackground({super.key, required this.baseColor});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  final List<Particle> particles = [];
  late AnimationController _controller;
  Offset? mousePosition;
  final int particleCount = 50;
  Size? _size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_updateParticles);
  }

  void _initializeParticles(Size size) {
    particles.clear();
    final random = Random();
    for (int i = 0; i < particleCount; i++) {
      particles.add(
        Particle(
          x: random.nextDouble() * size.width,
          y: random.nextDouble() * size.height,
          dx: (random.nextDouble() - 0.5) * 2,
          dy: (random.nextDouble() - 0.5) * 2,
          radius: random.nextDouble() * 3 + 1,
          color: widget.baseColor.withOpacity(random.nextDouble() * 0.5 + 0.1),
        ),
      );
    }
  }

  void _updateParticles() {
    if (_size == null) return;

    for (var particle in particles) {
      particle.x += particle.dx;
      particle.y += particle.dy;

      // Wrap particles around the screen
      if (particle.x < 0) particle.x = _size!.width;
      if (particle.x > _size!.width) particle.x = 0;
      if (particle.y < 0) particle.y = _size!.height;
      if (particle.y > _size!.height) particle.y = 0;

      // Interact with mouse
      if (mousePosition != null) {
        final dx = mousePosition!.dx - particle.x;
        final dy = mousePosition!.dy - particle.y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          particle.dx += dx * 0.001;
          particle.dy += dy * 0.001;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (_size != size) {
          _size = size;
          _initializeParticles(size);
        }

        return MouseRegion(
          onHover: (event) {
            setState(() {
              mousePosition = event.localPosition;
            });
          },
          onExit: (event) {
            setState(() {
              mousePosition = null;
            });
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: ParticlePainter(particles),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        paint,
      );
    }

    // Draw connections between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          final opacity = (1 - distance / 100) * 0.5;
          final paint = Paint()
            ..color = particles[i].color.withOpacity(opacity)
            ..strokeWidth = 1;

          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

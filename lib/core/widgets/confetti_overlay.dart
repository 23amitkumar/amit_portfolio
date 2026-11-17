import 'dart:math';
import 'package:flutter/material.dart';

/// Triggers a celebratory confetti explosion over the screen.
void showConfetti(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _ConfettiWidget(
      onFinished: () {
        if (entry.mounted) {
          entry.remove();
        }
      },
    ),
  );

  overlay.insert(entry);
}

class _ConfettiWidget extends StatefulWidget {
  const _ConfettiWidget({required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<_ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<_ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _random = Random();

  static const _colors = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFF43F5E),
    Color(0xFF3B82F6),
  ];

  @override
  void initState() {
    super.initState();
    _particles = List.generate(70, (_) => _createParticle());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..addListener(() {
        setState(() {
          for (final p in _particles) {
            p.x += p.vx;
            p.y += p.vy;
            p.vy += 0.18; // gravity
            p.vx *= 0.985; // drag
            p.rotation += p.rotationSpeed;
            p.opacity = (1.0 - (_controller.value * 0.95)).clamp(0.0, 1.0);
          }
        });
      });

    _controller.forward().then((_) => widget.onFinished());
  }

  _Particle _createParticle() {
    final angle = _random.nextDouble() * 2 * pi;
    final speed = 6.0 + _random.nextDouble() * 14.0;
    return _Particle(
      x: 0,
      y: 0,
      vx: cos(angle) * speed,
      vy: sin(angle) * speed - 6.0, // Initial upward burst
      size: 6.0 + _random.nextDouble() * 7.0,
      color: _colors[_random.nextInt(_colors.length)],
      rotation: _random.nextDouble() * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.25,
      isCircle: _random.nextBool(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(particles: _particles),
        ),
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double rotation;
  double rotationSpeed;
  double opacity = 1.0;
  bool isCircle;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles});

  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.4);

    for (final p in particles) {
      if (p.opacity <= 0) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(center.dx + p.x, center.dy + p.y);
      canvas.rotate(p.rotation);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

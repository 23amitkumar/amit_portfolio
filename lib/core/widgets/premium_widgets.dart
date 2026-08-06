import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import '../utils/responsive.dart';

/// Animated gradient mesh background with floating blobs.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.darkBackground,
                      const Color(0xFF0F0F14),
                      AppColors.darkBackground,
                    ]
                  : [
                      AppColors.lightBackground,
                      const Color(0xFFF0F0FF),
                      AppColors.lightBackground,
                    ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _BlobPainter(
                progress: _controller.value,
                isDark: isDark,
              ),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      (Color(0xFF6366F1), Offset(size.width * 0.15, size.height * 0.2)),
      (Color(0xFF8B5CF6), Offset(size.width * 0.85, size.height * 0.15)),
      (Color(0xFF06B6D4), Offset(size.width * 0.7, size.height * 0.75)),
      (Color(0xFFEC4899), Offset(size.width * 0.2, size.height * 0.8)),
    ];

    for (var i = 0; i < blobs.length; i++) {
      final (color, base) = blobs[i];
      final offset = Offset(
        base.dx + (20 * (progress - 0.5) * (i.isEven ? 1 : -1)),
        base.dy + (15 * (progress - 0.5) * (i.isOdd ? 1 : -1)),
      );
      final radius = size.width * (0.25 + (i * 0.05));

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.12),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: offset, radius: radius));

      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Glassmorphism container widget.
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.onTap,
    this.hoverEffect = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hoverEffect;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final canHover = widget.hoverEffect && Responsive.supportsHover(context);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: canHover && _hovered
          ? Matrix4.translationValues(0.0, -6.0, 0.0)
          : Matrix4.identity(),
      padding: widget.padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: AppColors.glassBackground(isDark),
        border: Border.all(
          color: canHover && _hovered
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.glassBorder(isDark),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: canHover && _hovered ? 0.45 : 0.3)
                : AppColors.primary.withValues(alpha: canHover && _hovered ? 0.14 : 0.06),
            blurRadius: canHover && _hovered ? 32 : 24,
            offset: Offset(0, canHover && _hovered ? 14 : 8),
          ),
        ],
      ),
      child: widget.child,
    );

    if (canHover) {
      card = MouseRegion(
        cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: card,
      );
    }

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: card);
    }
    return card;
  }
}

/// Premium gradient button with hover animation.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isLoading;
  final double? width;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: widget.isOutlined ? null : AppColors.primaryGradient,
                border: widget.isOutlined
                    ? Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.5,
                      )
                    : null,
                boxShadow: widget.isOutlined
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: _isHovered ? 0.4 : 0.25),
                          blurRadius: _isHovered ? 24 : 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  else ...[
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: 20,
                        color: widget.isOutlined
                            ? context.theme.colorScheme.onSurface
                            : Colors.white,
                      ),
                      8.horizontalSpace,
                    ],
                    Text(
                      widget.label,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: widget.isOutlined
                            ? context.theme.colorScheme.onSurface
                            : Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section header with title, subtitle, and optional action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.centerAlign = false,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final bool centerAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment:
            centerAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: centerAlign ? TextAlign.center : TextAlign.start,
            style: context.textTheme.displaySmall,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0),
          if (subtitle != null) ...[
            12.verticalSpace,
            Text(
              subtitle!,
              textAlign: centerAlign ? TextAlign.center : TextAlign.start,
              style: context.textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0),
          ],
          if (action != null) ...[
            16.verticalSpace,
            action!,
          ],
        ],
      ),
    );
  }
}

/// Animated counter widget.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.suffix,
    required this.label,
    this.delay = 0,
  });

  final double value;
  final String suffix;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tight = constraints.maxHeight < 100;

        return GlassCard(
          padding: EdgeInsets.symmetric(
            horizontal: tight ? 8 : (isMobile ? 10 : 16),
            vertical: tight ? 8 : (isMobile ? 10 : 16),
          ),
          hoverEffect: false,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: constraints.maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value),
                    duration: Duration(milliseconds: 1500 + delay),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) {
                      final display = value == value.roundToDouble()
                          ? val.round().toString()
                          : val.toStringAsFixed(1);
                      return Text(
                        '$display$suffix',
                        textAlign: TextAlign.center,
                        style: (tight
                                ? context.textTheme.titleLarge
                                : isMobile
                                    ? context.textTheme.headlineMedium
                                    : context.textTheme.displaySmall)
                            ?.copyWith(
                          foreground: Paint()
                            ..shader = AppColors.primaryGradient.createShader(
                              const Rect.fromLTWH(0, 0, 200, 70),
                            ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: tight ? 2 : 4),
                  Text(
                    label,
                    style: tight
                        ? context.textTheme.labelSmall
                        : isMobile
                            ? context.textTheme.bodySmall
                            : context.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }
}

/// Staggered entrance animation wrapper.
class StaggerItem extends StatelessWidget {
  const StaggerItem({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = 80,
  });

  final int index;
  final Widget child;
  final int baseDelay;

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: index * baseDelay);

    return child
        .animate()
        .fadeIn(delay: delay, duration: 500.ms)
        .slideY(
          begin: 0.15,
          end: 0,
          delay: delay,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          delay: delay,
          duration: 500.ms,
          curve: Curves.easeOutBack,
        );
  }
}

/// Loading skeleton placeholder.
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: isDark
                  ? [
                      AppColors.darkCard,
                      AppColors.darkBorder,
                      AppColors.darkCard,
                    ]
                  : [
                      AppColors.lightCard,
                      AppColors.lightBorder,
                      AppColors.lightCard,
                    ],
            ),
          ),
        );
      },
    );
  }
}

/// Typing animation text widget.
class TypingText extends StatefulWidget {
  const TypingText({
    super.key,
    required this.texts,
    this.speed = const Duration(milliseconds: 80),
    this.pause = const Duration(milliseconds: 2000),
  });

  final List<String> texts;
  final Duration speed;
  final Duration pause;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  String _display = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleStep(Duration.zero);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleStep(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _step);
  }

  void _step() {
    if (!mounted) return;

    final current = widget.texts[_textIndex];

    if (!_isDeleting) {
      if (_charIndex < current.length) {
        setState(() {
          _charIndex++;
          _display = current.substring(0, _charIndex);
        });
        _scheduleStep(widget.speed);
        return;
      }
      _isDeleting = true;
      _scheduleStep(widget.pause);
      return;
    }

    if (_charIndex > 0) {
      setState(() {
        _charIndex--;
        _display = current.substring(0, _charIndex);
      });
      _scheduleStep(widget.speed ~/ 2);
      return;
    }

    _isDeleting = false;
    _textIndex = (_textIndex + 1) % widget.texts.length;
    _scheduleStep(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _display,
              style: context.textTheme.headlineMedium?.copyWith(
                foreground: Paint()
                  ..shader = AppColors.primaryGradient.createShader(
                    const Rect.fromLTWH(0, 0, 300, 50),
                  ),
              ),
            ),
            Container(
              width: 3,
              height: 28,
              margin: const EdgeInsets.only(left: 4),
              color: AppColors.primary,
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fade(begin: 1, end: 0, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}

/// Progress bar with animated fill.
class SkillProgressBar extends StatelessWidget {
  const SkillProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.delay = 0,
  });

  final double progress;
  final Color color;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: Duration(milliseconds: 1200 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom cursor overlay for web/desktop.
class CustomCursor extends StatefulWidget {
  const CustomCursor({super.key, required this.child});

  final Widget child;

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  Offset _position = Offset.zero;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    if (!Responsive.supportsHover(context)) return widget.child;

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onExit: (_) => setState(() => _visible = false),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: (event) {
          setState(() {
            _position = event.position;
            _visible = true;
          });
        },
        onPointerMove: (event) {
          setState(() {
            _position = event.position;
            _visible = true;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            if (_visible)
              Positioned(
                left: _position.dx - 14,
                top: _position.dy - 14,
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.75),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Scroll progress indicator at top.
class ScrollProgressBar extends StatelessWidget {
  const ScrollProgressBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 3,
        backgroundColor: Colors.transparent,
        color: AppColors.primary,
      ),
    );
  }
}

/// Back to top floating button.
class BackToTopButton extends StatelessWidget {
  const BackToTopButton({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedScale(
        scale: visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton.small(
          onPressed: visible ? onPressed : null,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          child: const Icon(Icons.arrow_upward_rounded),
        ),
      ),
    );
  }
}

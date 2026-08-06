import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import '../utils/responsive.dart';
import '../../features/shell/controllers/shell_controller.dart';
import 'premium_widgets.dart';

/// Consistent page wrapper with scroll tracking and max width.
class PageScaffold extends StatefulWidget {
  const PageScaffold({
    super.key,
    required this.child,
    this.onScroll,
    this.scrollController,
    this.showBackground = true,
  });

  final Widget child;
  final void Function(double progress)? onScroll;
  final ScrollController? scrollController;
  final bool showBackground;

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold> {
  late final ScrollController _controller;
  ShellController? _shell;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    if (widget.onScroll != null) {
      _shell = Get.find<ShellController>();
      _shell!.registerScrollController(_controller);
      _controller.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    if (widget.onScroll != null) {
      _controller.removeListener(_handleScroll);
      _shell?.unregisterScrollController(_controller);
    }
    if (widget.scrollController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleScroll() {
    if (!_controller.hasClients || widget.onScroll == null) return;
    final max = _controller.position.maxScrollExtent;
    final progress = max > 0 ? _controller.offset / max : 0.0;
    widget.onScroll!(progress);
  }

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.contentWidth(context)),
            child: Padding(
              padding: Responsive.pagePadding(context),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (!widget.showBackground) return content;

    return AnimatedBackground(child: content);
  }
}

/// Profile avatar with animated gradient ring.
class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    super.key,
    this.size = 200,
    this.initials = 'AK',
  });

  final double size;
  final String initials;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ringController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _ringController.value * 2 * pi,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                        const Color(0xFF06B6D4),
                        AppColors.primary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            width: widget.size - 8,
            height: widget.size - 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
            ),
            child: Center(
              child: Text(
                widget.initials,
                style: TextStyle(
                  fontSize: widget.size * 0.3,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = AppColors.primaryGradient.createShader(
                      Rect.fromLTWH(0, 0, widget.size, widget.size),
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), duration: 700.ms, curve: Curves.easeOutBack);
  }
}

/// Horizontal filter chips.
class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final chipIndex = entry.key;
          final isSelected = item == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onSelected(item),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : context.theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : (context.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: chipIndex * 60), duration: 350.ms)
                .slideX(begin: 0.2, end: 0, delay: Duration(milliseconds: chipIndex * 60), duration: 350.ms),
          );
        }).toList(),
      ),
    );
  }
}

/// Star rating display.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 20});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = i == rating.floor() && rating % 1 >= 0.5;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          color: AppColors.star,
          size: size,
        );
      }),
    );
  }
}

/// Social link button.
class SocialButton extends StatefulWidget {
  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.diagonal3Values(_hovered ? 1.08 : 1.0, _hovered ? 1.08 : 1.0, 1.0),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 20,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _hovered ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon,
              SizedBox(width: isMobile ? 8 : 10),
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 13 : 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

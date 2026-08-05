import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import '../utils/responsive.dart';
import 'premium_widgets.dart';

/// Consistent page wrapper with scroll tracking and max width.
class PageScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final controller = scrollController ?? ScrollController();

    if (onScroll != null) {
      controller.addListener(() {
        if (!controller.hasClients) return;
        final max = controller.position.maxScrollExtent;
        final progress = max > 0 ? controller.offset / max : 0.0;
        onScroll!(progress);
      });
    }

    final content = Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.contentWidth(context)),
            child: Padding(
              padding: Responsive.pagePadding(context),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (!showBackground) return content;

    return AnimatedBackground(child: content);
  }
}

/// Profile avatar with gradient ring.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = 200,
    this.initials = 'AK',
  });

  final double size;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              foreground: Paint()..shader = AppColors.primaryGradient.createShader(
                    Rect.fromLTWH(0, 0, size, size),
                  ),
            ),
          ),
        ),
      ),
    );
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
        children: items.map((item) {
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
            ),
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.diagonal3Values(_hovered ? 1.08 : 1.0, _hovered ? 1.08 : 1.0, 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _hovered ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon,
              10.horizontalSpace,
              Text(widget.label, style: TextStyle(color: widget.color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/testimonials_controller.dart';

/// Testimonials carousel screen.
class TestimonialsView extends GetView<TestimonialsController> {
  const TestimonialsView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        children: [
          SectionHeader(
            title: 'Client Testimonials',
            subtitle: 'What clients say about working with me',
            centerAlign: true,
          ),
          Obx(() {
            final testimonial =
                controller.testimonials[controller.currentIndex.value] as TestimonialModel;
            return Column(
              children: [
                _TestimonialCard(testimonial: testimonial),
                32.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: controller.previous,
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    24.horizontalSpace,
                    ...List.generate(controller.testimonials.length, (i) {
                      final isActive = controller.currentIndex.value == i;
                      return GestureDetector(
                        onTap: () => controller.goTo(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isActive
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    }),
                    24.horizontalSpace,
                    IconButton(
                      onPressed: controller.next,
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.testimonial});

  final TestimonialModel testimonial;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.format_quote_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
          24.verticalSpace,
          Text(
            '"${testimonial.quote}"',
            style: context.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          32.verticalSpace,
          StarRating(rating: testimonial.rating, size: 24),
          24.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  testimonial.avatarInitials,
                  style: context.textTheme.titleMedium?.copyWith(color: AppColors.primary),
                ),
              ),
              16.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(testimonial.name, style: context.textTheme.titleMedium),
                  Text(
                    '${testimonial.role}, ${testimonial.company}',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate(key: ValueKey(testimonial.name))
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

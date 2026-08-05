import 'package:flutter/material.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/about_controller.dart';

/// About screen with timeline and journey.
class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'About Me',
            subtitle: 'My journey as a Flutter developer',
          ),
          _IntroSection(),
          64.verticalSpace,
          Text('My Journey', style: context.textTheme.headlineMedium),
          32.verticalSpace,
          _TimelineSection(items: controller.journey.cast<TimelineModel>()),
          64.verticalSpace,
          Text('Education', style: context.textTheme.headlineMedium),
          32.verticalSpace,
          _TimelineSection(items: controller.education.cast<TimelineModel>()),
        ],
      ),
    );
  }
}

class _IntroSection extends GetView<AboutController> {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return GlassCard(
      child: isMobile
          ? Column(
              children: [
                const ProfileAvatar(size: 120),
                24.verticalSpace,
                Text(controller.introduction, style: context.textTheme.bodyLarge),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileAvatar(size: 160),
                32.horizontalSpace,
                Expanded(
                  child: Text(controller.introduction, style: context.textTheme.bodyLarge),
                ),
              ],
            ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.items});

  final List<TimelineModel> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return StaggerItem(
          index: index,
          child: _TimelineTile(item: item, isLast: index == items.length - 1),
        );
      }).toList(),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.item, required this.isLast});

  final TimelineModel item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: item.isHighlighted ? AppColors.primaryGradient : null,
                  color: item.isHighlighted ? null : AppColors.primary.withValues(alpha: 0.3),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          20.horizontalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.title, style: context.textTheme.titleLarge),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.period,
                            style: context.textTheme.labelMedium?.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      item.subtitle,
                      style: context.textTheme.titleMedium?.copyWith(color: AppColors.primary),
                    ),
                    12.verticalSpace,
                    Text(item.description, style: context.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

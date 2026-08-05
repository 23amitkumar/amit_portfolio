import 'package:flutter/material.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/experience_controller.dart';

/// Experience screen with interactive timeline.
class ExperienceView extends GetView<ExperienceController> {
  const ExperienceView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Work Experience',
            subtitle: 'Professional journey and achievements',
          ),
          ...controller.experiences.asMap().entries.map((entry) {
            return StaggerItem(
              index: entry.key,
              child: _ExperienceCard(experience: entry.value as ExperienceModel),
            );
          }),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({required this.experience});

  final ExperienceModel experience;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GlassCard(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business_rounded, color: Colors.white),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.experience.role, style: context.textTheme.titleLarge),
                      Text(
                        widget.experience.company,
                        style: context.textTheme.titleMedium?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.experience.duration, style: context.textTheme.labelMedium),
                    Text(widget.experience.location, style: context.textTheme.bodySmall),
                  ],
                ),
                8.horizontalSpace,
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.expand_more_rounded),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Responsibilities', style: context.textTheme.titleSmall),
                    8.verticalSpace,
                    ...widget.experience.responsibilities.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_right_rounded, size: 20, color: AppColors.primary),
                            4.horizontalSpace,
                            Expanded(child: Text(r, style: context.textTheme.bodySmall)),
                          ],
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Text('Technologies', style: context.textTheme.titleSmall),
                    8.verticalSpace,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.experience.technologies.map((t) {
                        return Chip(
                          label: Text(t, style: const TextStyle(fontSize: 12)),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    16.verticalSpace,
                    Text('Achievements', style: context.textTheme.titleSmall),
                    8.verticalSpace,
                    ...widget.experience.achievements.map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.emoji_events_outlined, size: 18, color: AppColors.star),
                            8.horizontalSpace,
                            Expanded(child: Text(a, style: context.textTheme.bodySmall)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}

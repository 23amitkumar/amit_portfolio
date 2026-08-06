import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/skills_controller.dart';

/// Skills screen with animated cards and filters.
class SkillsView extends GetView<SkillsController> {
  const SkillsView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();
    final columns = Responsive.value(context: context, mobile: 1, tablet: 2, desktop: 3);

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Skills & Expertise',
            subtitle: 'Technologies I work with daily',
          ),
          TextField(
            onChanged: controller.updateSearch,
            decoration: InputDecoration(
              hintText: 'Search skills...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: context.isDarkMode ? AppColors.darkCard : AppColors.lightCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.08, end: 0, duration: 400.ms),
          24.verticalSpace,
          Obx(
            () => FilterChips(
              items: controller.categories,
              selected: controller.selectedCategory.value,
              onSelected: controller.selectCategory,
            ),
          ),
          32.verticalSpace,
          Obx(
            () {
              final skills = controller.filteredSkills;
              if (Responsive.isMobile(context)) {
                return Column(
                  children: skills.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: entry.key < skills.length - 1 ? 12 : 0),
                      child: StaggerItem(
                        index: entry.key,
                        child: _SkillCard(skill: entry.value, index: entry.key),
                      ),
                    );
                  }).toList(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: columns == 3 ? 240 : 220,
                ),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return StaggerItem(
                    index: index,
                    child: _SkillCard(skill: skills[index], index: index, compact: true),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill, required this.index, this.compact = false});

  final SkillModel skill;
  final int index;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = Color(skill.color);

    return GlassCard(
      hoverEffect: !compact,
      padding: compact ? const EdgeInsets.all(16) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(skill.icon, style: TextStyle(fontSize: compact ? 26 : 32)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill.experience,
                  style: context.textTheme.labelSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 10 : 16),
          Text(
            skill.name,
            style: compact ? context.textTheme.titleMedium : context.textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Text(
            skill.category,
            style: context.textTheme.labelMedium?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            skill.description,
            style: context.textTheme.bodySmall,
            maxLines: compact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: compact ? 10 : 12),
          SkillProgressBar(progress: skill.progress, color: color, delay: index * 50),
          4.verticalSpace,
          Text(
            '${(skill.progress * 100).round()}%',
            style: context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

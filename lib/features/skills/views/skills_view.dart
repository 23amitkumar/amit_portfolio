import 'package:flutter/material.dart';

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
          ),
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
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: Responsive.isMobile(context) ? 1.1 : 0.95,
              ),
              itemCount: controller.filteredSkills.length,
              itemBuilder: (context, index) {
                return StaggerItem(
                  index: index,
                  child: _SkillCard(skill: controller.filteredSkills[index], index: index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill, required this.index});

  final SkillModel skill;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = Color(skill.color);

    return GlassCard(
      hoverEffect: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(skill.icon, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          16.verticalSpace,
          Text(skill.name, style: context.textTheme.titleLarge),
          4.verticalSpace,
          Text(skill.category, style: context.textTheme.labelMedium?.copyWith(color: color)),
          12.verticalSpace,
          Text(
            skill.description,
            style: context.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          12.verticalSpace,
          SkillProgressBar(progress: skill.progress, color: color, delay: index * 50),
          6.verticalSpace,
          Text(
            '${(skill.progress * 100).round()}%',
            style: context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

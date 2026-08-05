import 'package:flutter/material.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/achievements_controller.dart';

/// Achievements screen with animated badge cards.
class AchievementsView extends GetView<AchievementsController> {
  const AchievementsView({super.key});

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
            title: 'Achievements',
            subtitle: 'Milestones that define my work ethic',
            centerAlign: true,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            itemCount: controller.achievements.length,
            itemBuilder: (context, index) {
              return StaggerItem(
                index: index,
                child: _AchievementCard(achievement: controller.achievements[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatefulWidget {
  const _AchievementCard({required this.achievement});

  final AchievementModel achievement;

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.achievement.color);

    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 4 * _floatController.value),
                child: child,
              );
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(widget.achievement.icon, style: const TextStyle(fontSize: 36)),
              ),
            ),
          ),
          20.verticalSpace,
          Text(
            widget.achievement.title,
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          Text(
            widget.achievement.description,
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

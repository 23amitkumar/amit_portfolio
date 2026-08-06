import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/home_controller.dart';

/// Home screen with hero section and statistics.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();
    final isMobile = Responsive.isMobile(context);

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroSection(isMobile: isMobile),
          80.verticalSpace,
          _StatsSection(),
          80.verticalSpace,
          _WorkTogetherSection(),
          40.verticalSpace,
        ],
      ),
    );
  }
}

class _HeroSection extends GetView<HomeController> {
  const _HeroSection({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return isMobile ? _buildMobile(context) : _buildDesktop(context);
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        const ProfileAvatar(size: 160)
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        32.verticalSpace,
        _HeroText(),
        32.verticalSpace,
        _HeroButtons(isMobile: true),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 3, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroText(),
            40.verticalSpace,
            _HeroButtons(isMobile: false),
          ],
        )),
        48.horizontalSpace,
        Expanded(
          flex: 2,
          child: const ProfileAvatar(size: 280)
              .animate()
              .fadeIn(delay: 200.ms, duration: 800.ms)
              .slideX(begin: 0.2, end: 0),
        ),
      ],
    );
  }
}

class _HeroText extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              8.horizontalSpace,
              Text(
                'Available for hire',
                style: context.textTheme.labelMedium?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        24.verticalSpace,
        Text(
          'Hi, I\'m ${controller.developerName.split(' ').first}',
          style: context.textTheme.displayMedium,
        ).animate().fadeIn(delay: 100.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
        8.verticalSpace,
        Text(
          controller.developerRole,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        16.verticalSpace,
        TypingText(texts: AppConstants.typingTexts),
        24.verticalSpace,
        Text(
          controller.aboutSnippet,
          style: context.textTheme.bodyLarge,
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
        16.verticalSpace,
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
            6.horizontalSpace,
            Text(controller.location, style: context.textTheme.bodyMedium),
          ],
        ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
      ],
    );
  }
}

class _HeroButtons extends GetView<HomeController> {
  const _HeroButtons({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        GradientButton(
          label: AppStrings.hireMe,
          icon: Icons.rocket_launch_rounded,
          onPressed: controller.navigateToContact,
        ),
        GradientButton(
          label: AppStrings.downloadResume,
          icon: Icons.download_rounded,
          isOutlined: true,
          onPressed: controller.downloadResume,
        ),
        GradientButton(
          label: AppStrings.viewProjects,
          icon: Icons.folder_open_rounded,
          isOutlined: true,
          onPressed: controller.navigateToProjects,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

class _StatsSection extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final stats = controller.stats;
    final columns = Responsive.value(context: context, mobile: 2, tablet: 2, desktop: 4);

    return Column(
      children: [
        SectionHeader(
          title: 'By the Numbers',
          subtitle: 'Delivering excellence across every project',
          centerAlign: true,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: Responsive.isMobile(context)
                ? 108
                : columns == 4
                    ? 130
                    : 120,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return AnimatedCounter(
              value: stat.value,
              suffix: stat.suffix,
              label: stat.label,
              delay: index * 100,
            );
          },
        ),
      ],
    );
  }
}

class _WorkTogetherSection extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 24 : 48),
      child: Column(
        children: [
          Text(
            AppStrings.letsWorkTogether,
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Text(
            'Have a project in mind? Let\'s build something amazing together.',
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          32.verticalSpace,
          GradientButton(
            label: 'Start a Conversation',
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: controller.navigateToContact,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }
}

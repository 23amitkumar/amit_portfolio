import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../projects/services/projects_service.dart';
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
          48.verticalSpace,
          const _TechMarquee(),
          80.verticalSpace,
          _StatsSection(),
          80.verticalSpace,
          const _FeaturedProjectsSection(),
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
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .shimmer(delay: 2200.ms, duration: 1800.ms),
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

class _TechMarquee extends StatefulWidget {
  const _TechMarquee();

  @override
  State<_TechMarquee> createState() => _TechMarqueeState();
}

class _TechMarqueeState extends State<_TechMarquee> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animController;

  static final _techs = [
    ('Flutter', const FaIcon(FontAwesomeIcons.flutter, size: 14, color: Color(0xFF02569B)), const Color(0xFF02569B)),
    ('Dart', const Icon(Icons.code_rounded, size: 15, color: Color(0xFF0175C2)), const Color(0xFF0175C2)),
    ('Firebase', const FaIcon(FontAwesomeIcons.fire, size: 14, color: Color(0xFFFFA611)), const Color(0xFFFFA611)),
    ('Google Maps', const Icon(Icons.map_rounded, size: 15, color: Color(0xFF34A853)), const Color(0xFF34A853)),
    ('GetX', const Icon(Icons.bolt_rounded, size: 15, color: Color(0xFF8B5CF6)), const Color(0xFF8B5CF6)),
    ('Clean Architecture', const Icon(Icons.layers_outlined, size: 15, color: Color(0xFF6366F1)), const Color(0xFF6366F1)),
    ('MVVM', const Icon(Icons.architecture_rounded, size: 15, color: Color(0xFF06B6D4)), const Color(0xFF06B6D4)),
    ('Stripe', const FaIcon(FontAwesomeIcons.stripe, size: 14, color: Color(0xFF635BFF)), const Color(0xFF635BFF)),
    ('Razorpay', const Icon(Icons.payment_rounded, size: 15, color: Color(0xFF0284C7)), const Color(0xFF0284C7)),
    ('Socket.IO', const Icon(Icons.wifi_tethering_rounded, size: 15, color: Color(0xFFEC4899)), const Color(0xFFEC4899)),
    ('REST APIs', const Icon(Icons.cloud_queue_rounded, size: 15, color: Color(0xFF10B981)), const Color(0xFF10B981)),
    ('In-App Purchases', const Icon(Icons.shopping_bag_outlined, size: 15, color: Color(0xFFF59E0B)), const Color(0xFFF59E0B)),
    ('SQLite / Hive', const Icon(Icons.storage_rounded, size: 15, color: Color(0xFF14B8A6)), const Color(0xFF14B8A6)),
    ('CI/CD & Fastlane', const Icon(Icons.rocket_launch_outlined, size: 15, color: Color(0xFFE11D48)), const Color(0xFFE11D48)),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..addListener(() {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          if (max > 0) {
            final target = _animController.value * max;
            _scrollController.jumpTo(target);
          }
        }
      });
    _animController.repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [..._techs, ..._techs, ..._techs];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final title = item.$1;
          final iconWidget = item.$2;
          final color = item.$3;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  iconWidget,
                  8.horizontalSpace,
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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

class _FeaturedProjectsSection extends GetView<HomeController> {
  const _FeaturedProjectsSection();

  Future<void> _launch(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url.trim());
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsService = Get.find<ProjectsService>();
    final featured = projectsService.getAllProjects().take(4).toList();
    final isDesktop = Responsive.isDesktop(context);

    return Column(
      children: [
        SectionHeader(
          title: 'Featured Live Apps',
          subtitle: 'A selection of production-ready applications from Google Play & App Store',
          centerAlign: true,
        ),
        if (isDesktop)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 210,
            ),
            itemCount: featured.length,
            itemBuilder: (context, index) => _FeaturedAppCard(project: featured[index], onLaunch: _launch),
          )
        else
          Column(
            children: featured
                .map((project) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _FeaturedAppCard(project: project, onLaunch: _launch),
                    ))
                .toList(),
          ),
        36.verticalSpace,
        GradientButton(
          label: 'Explore All 13 Live Projects',
          icon: Icons.arrow_forward_rounded,
          onPressed: controller.navigateToProjects,
        ),
      ],
    );
  }
}

class _FeaturedAppCard extends StatelessWidget {
  const _FeaturedAppCard({required this.project, required this.onLaunch});

  final ProjectModel project;
  final ValueChanged<String?> onLaunch;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: project.gradientColors.map((c) => Color(c)).toList(),
    );

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(project.gradientColors.first).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    project.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        project.category,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Expanded(
            child: Text(
              project.description,
              style: context.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          8.verticalSpace,
          Row(
            children: [
              if (project.playStoreUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _StorePill(
                    icon: FontAwesomeIcons.googlePlay,
                    label: 'Play Store',
                    color: const Color(0xFF00E676),
                    onTap: () => onLaunch(project.playStoreUrl),
                  ),
                ),
              if (project.appStoreUrl != null)
                _StorePill(
                  icon: FontAwesomeIcons.apple,
                  label: 'App Store',
                  color: context.isDarkMode ? Colors.white : Colors.black87,
                  onTap: () => onLaunch(project.appStoreUrl),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StorePill extends StatelessWidget {
  const _StorePill({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final FaIconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 12, color: color),
            6.horizontalSpace,
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
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

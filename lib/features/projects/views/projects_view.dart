import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/projects_controller.dart';

/// Projects showcase with filtering and carousel.
class ProjectsView extends GetView<ProjectsController> {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Featured Projects',
            subtitle: 'Production-ready apps across diverse industries',
          ),
          TextField(
            onChanged: controller.updateSearch,
            decoration: InputDecoration(
              hintText: 'Search projects...',
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
          Obx(() {
            final projects = controller.filteredProjects;
            if (projects.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Text('No projects found', style: context.textTheme.bodyLarge),
                ),
              );
            }
            return _ProjectsGrid(projects: projects);
          }),
        ],
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      return Column(
        children: projects.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: entry.key < projects.length - 1 ? 16 : 0),
            child: StaggerItem(
              index: entry.key,
              child: _ProjectCard(project: entry.value),
            ),
          );
        }).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 460,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return StaggerItem(
          index: index,
          child: _ProjectCard(project: projects[index]),
        );
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project});

  final ProjectModel project;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

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
    final isMobile = Responsive.isMobile(context);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: widget.project.gradientColors.map((c) => Color(c)).toList(),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: isMobile ? 100 : 130,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  widget.project.icon,
                  style: TextStyle(
                    fontSize: isMobile ? 44 : 52,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -3, end: 3, duration: 2200.ms, curve: Curves.easeInOut),
              ),
              Positioned(
                top: isMobile ? 10 : 12,
                right: isMobile ? 10 : 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 10,
                    vertical: isMobile ? 4 : 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.project.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 10 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(isMobile ? 14 : 16),
          child: _buildDetails(context, isMobile),
        ),
      ],
    );

    final primaryColor = Color(widget.project.gradientColors.first);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _hovered ? -8.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: GlassCard(
          padding: EdgeInsets.zero,
          hoverEffect: false,
          child: InkWell(
            onTap: () => _showProjectDetails(context, widget.project),
            borderRadius: BorderRadius.circular(20),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.project.name,
          style: isMobile ? context.textTheme.titleMedium : context.textTheme.titleLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        6.verticalSpace,
        Text(
          widget.project.description,
          style: context.textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        10.verticalSpace,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.project.techStack.take(4).map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tech, style: context.textTheme.labelSmall),
            );
          }).toList(),
        ),
        10.verticalSpace,
        Row(
          children: [
            Icon(Icons.schedule, size: 14, color: AppColors.primary),
            4.horizontalSpace,
            Text(widget.project.duration, style: context.textTheme.labelSmall),
            12.horizontalSpace,
            Icon(Icons.person_outline, size: 14, color: AppColors.primary),
            4.horizontalSpace,
            Expanded(
              child: Text(
                widget.project.role,
                style: context.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.project.playStoreUrl != null)
              _StoreBadgeButton(
                icon: FontAwesomeIcons.googlePlay,
                label: 'Play Store',
                color: const Color(0xFF00E676),
                onTap: () => _launch(widget.project.playStoreUrl),
              ),
            if (widget.project.appStoreUrl != null)
              _StoreBadgeButton(
                icon: FontAwesomeIcons.apple,
                label: 'App Store',
                color: context.isDarkMode ? Colors.white : Colors.black87,
                onTap: () => _launch(widget.project.appStoreUrl),
              ),
            _DetailsPill(
              onTap: () => _showProjectDetails(context, widget.project),
            ),
          ],
        ),
      ],
    );
  }
}

void _showProjectDetails(BuildContext context, ProjectModel project) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    builder: (context) => _ProjectDetailsDialog(project: project),
  );
}

class _ProjectDetailsDialog extends StatelessWidget {
  const _ProjectDetailsDialog({required this.project});

  final ProjectModel project;

  Future<void> _launchUrlStr(String? url) async {
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
    final isMobile = Responsive.isMobile(context);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: project.gradientColors.map((c) => Color(c)).toList(),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 24 : 40,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: isMobile ? 120 : 150,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        project.icon,
                        style: TextStyle(
                          fontSize: isMobile ? 54 : 64,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.3),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          project.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 18 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: AppColors.primary),
                          6.horizontalSpace,
                          Text(project.duration, style: context.textTheme.labelMedium),
                          16.horizontalSpace,
                          Icon(Icons.person_outline, size: 16, color: AppColors.primary),
                          6.horizontalSpace,
                          Expanded(
                            child: Text(
                              project.role,
                              style: context.textTheme.labelMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      Text(
                        project.description,
                        style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      20.verticalSpace,
                      Text(
                        'Key Features',
                        style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      12.verticalSpace,
                      ...project.features.map(
                        (feat) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, size: 13, color: AppColors.success),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Text(feat, style: context.textTheme.bodyMedium),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      Text(
                        'Technologies Used',
                        style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      12.verticalSpace,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.techStack.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              tech,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      24.verticalSpace,
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (project.playStoreUrl != null)
                            _LargeStoreButton(
                              icon: FontAwesomeIcons.googlePlay,
                              title: 'GET IT ON',
                              subtitle: 'Google Play',
                              iconColor: const Color(0xFF00E676),
                              onTap: () => _launchUrlStr(project.playStoreUrl),
                            ),
                          if (project.appStoreUrl != null)
                            _LargeStoreButton(
                              icon: FontAwesomeIcons.apple,
                              title: 'Download on the',
                              subtitle: 'App Store',
                              iconColor: context.isDarkMode ? Colors.white : Colors.black87,
                              onTap: () => _launchUrlStr(project.appStoreUrl),
                            ),
                        ],
                      ),
                    ],
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

class _StoreBadgeButton extends StatelessWidget {
  const _StoreBadgeButton({
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
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

class _DetailsPill extends StatelessWidget {
  const _DetailsPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, size: 13, color: AppColors.primary),
            4.horizontalSpace,
            Text(
              'Details',
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LargeStoreButton extends StatelessWidget {
  const _LargeStoreButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  final FaIconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 24, color: iconColor),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: context.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
